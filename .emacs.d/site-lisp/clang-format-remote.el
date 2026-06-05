;;; clang-format-remote.el --- clang-format-for-remote  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'clang-format)
(require 'tramp)

(defgroup clang-format-remote nil
  "Remote version for clang-format."
  :group 'clang-format)

(defcustom clang-format-remote-executable "clang-format"
  "The clang-format command to call on the remote."
  :type 'string
  :group 'clang-format-remote)

(defcustom clang-format-remote-executable-alist nil
  "Custom path to clang-format executable in projects.
e.g. \\='((\"build-server\" . \"/opt/llvm/bin/clang-format\")
      (\"dev-box\"      . \"clang-format-18\"))"
  :type '(alist :key-type string :value-type string)
  :group 'clang-format-remote)

(defun clang-format-remote--file-remote-p (filename)
  "Check if FILENAME is remote file."
  (and (featurep 'tramp)
       filename
       (file-remote-p filename)))

(defun clang-format-remote--host (filename)
  "Get the hostname of FILENAME by tramp."
  (when (clang-format-remote--file-remote-p filename)
    (tramp-file-name-host
     (tramp-dissect-file-name filename))))

(defun clang-format-remote--get-executable (&optional filename)
  "Return the executable for clang-format.
If FILENAME is remote, call `clang-format-remote-executable' or
corresponding executable registered in `clang-format-remote-executable-alist'.
Otherwise, just use `clang-format-executable' defined in `clang-format.el'."
  (let* ((fname (or filename (buffer-file-name (buffer-base-buffer))))
         (remote-p (clang-format-remote--file-remote-p fname)))
    (if remote-p
        (let* ((host (clang-format-remote--host fname))
               (entry (and host
                           (assoc host clang-format-remote-executable-alist))))
          (if entry
              (cdr entry)
            clang-format-remote-executable))
      ;; local
      clang-format-executable)))

(defun clang-format--region-impl (start end &optional style assume-file-name lines)
  "Remote version of `clang-format--region-impl'(START/END/STYLE/ASSUME-FILE-NAME/LINES)."
  (unless style
    (setq style clang-format-style))
  (unless assume-file-name
    (setq assume-file-name (buffer-file-name (buffer-base-buffer))))

  (let ((executable (clang-format-remote--get-executable assume-file-name))
        (is-remote (clang-format-remote--file-remote-p assume-file-name)))

    (when lines
      (setq lines (mapcar (lambda (range)
                            (format "--lines=%d:%d" (car range) (cdr range)))
                          lines)))

    (let ((file-start (clang-format--bufferpos-to-filepos start 'approximate
                                                          'utf-8-unix))
          (file-end (clang-format--bufferpos-to-filepos end   'approximate
                                                        'utf-8-unix))
          (cursor (clang-format--bufferpos-to-filepos (point) 'exact
                                                      'utf-8-unix))
          (temp-buffer (generate-new-buffer " *clang-format-temp*"))
          (temp-file (make-temp-file "clang-format"))
          (default-process-coding-system '(utf-8-unix . utf-8-unix)))

      (unwind-protect
          (let* ((args `("--output-replacements-xml"
                         ,@(and assume-file-name
                                (list "--assume-filename"
                                      ;; get local path from remote path
                                      (if is-remote
                                          (tramp-file-local-name assume-file-name)
                                        assume-file-name)))
                         ,@(and style (list "--style" style))
                         "--fallback-style" ,clang-format-fallback-style
                         ,@(and lines lines)
                         ,@(and (not lines)
                                (list "--offset" (number-to-string file-start)
                                      "--length" (number-to-string
                                                  (- file-end file-start))))
                         "--cursor" ,(number-to-string cursor)))
                 ;; process-file calls remote process if default-directory is TRAMP
                 (status
                  (if is-remote
                      ;; process-file does not send the result to stdin, so save on a remote temp file
                      (let* ((remote-tmp
                              (tramp-make-tramp-file-name
                               (tramp-dissect-file-name assume-file-name)
                               (concat "/tmp/clang-format-src-"
                                       (format "%d" (random 100000)))))
                             (_ (write-region start end remote-tmp nil 'nomessage))
                             (result
                              (apply #'process-file
                                     executable
                                     remote-tmp ; remote temp file instead of stdin
                                     `(,temp-buffer ,temp-file)
                                     nil
                                     args)))
                        (ignore-errors (delete-file remote-tmp))
                        result)
                    ;; local
                    (apply #'call-process-region
                           nil nil executable
                           nil `(,temp-buffer ,temp-file) nil
                           args)))
                 (stderr
                  (with-temp-buffer
                    (unless (zerop (cadr (insert-file-contents temp-file)))
                      (insert ": "))
                    (buffer-substring-no-properties
                     (point-min) (line-end-position)))))

            (cond
             ((stringp status)
              (error "(clang-format killed by signal %s%s)" status stderr))
             ((not (zerop status))
              (error "(clang-format failed with code %d%s)" status stderr)))

            (cl-destructuring-bind (replacements cursor incomplete-format)
                (with-current-buffer temp-buffer
                  (clang-format--extract (car (xml-parse-region))))
              (save-excursion
                (dolist (rpl replacements)
                  (apply #'clang-format--replace rpl)))
              (when cursor
                (goto-char (clang-format--filepos-to-bufferpos cursor 'exact
                                                               'utf-8-unix)))
              (if incomplete-format
                  (message "(clang-format: incomplete (syntax errors)%s)" stderr)
                (message "(clang-format: success [%s]%s)"
                         (if is-remote "remote" "local")
                         stderr))))

        (with-demoted-errors "clang-format: Failed to delete temporary file: %S"
          (delete-file temp-file))
        (when (buffer-name temp-buffer) (kill-buffer temp-buffer))))))

(defun clang-format-remote-show-executable ()
  "Check which clang-format is used on current buffer."
  (interactive)
  (let* ((fname (buffer-file-name (buffer-base-buffer)))
         (exe (clang-format-remote--get-executable fname))
         (where (if (clang-format-remote--file-remote-p fname) "remote" "local")))
    (message "clang-format (%s): %s" where exe)))

(provide 'clang-format-remote)

;;; clang-format-remote.el ends here
