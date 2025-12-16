;;; 30_tabbar.el --- tabbar settings

;;; Commentary:
;;

;;; Code:

(with-eval-after-load 'magit
  (require 'forge))

(use-package forge
  :after magit)

(defun github ()
  (interactive)
  (let* ((file (buffer-file-name))
         (line (line-number-at-pos))
         (rel (file-relative-name file (vc-root-dir)))
         (url (string-trim
               (shell-command-to-string
                (format "gh browse /%s:%d --no-browser"
                        rel line)))))
    (browse-url url)))

;;; End:

;;; 32_magit ends here
