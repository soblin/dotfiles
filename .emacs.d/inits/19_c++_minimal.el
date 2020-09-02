;;; 19_c++_minimal.el --- settings for c++

;;; Commentary:
;;

;;; Code:

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))

(load-file "~/.emacs.d/elpa/google-c-style-20180130.1736/google-c-style.el")
(require 'google-c-style)
(load-file "~/.emacs.d/elpa/rtags/rtags.el")
(require 'rtags)

(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-hook 'google-set-c-style)
(add-hook 'c++-mode-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

(when (require 'rtags nil 'noerror)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (when (rtags-is-indexed)
                (local-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
                (local-set-key (kbd "M-;") 'rtags-find-symbol)
                (local-set-key (kbd "M-@") 'rtags-find-references)
                (local-set-key (kbd "M-,") 'rtags-location-stack-back)))))

(defun ins-include-guard (guard)
  "Insert include guard as GUARD."
  (interactive "sEnter include guard:")
  (progn (insert "#ifndef " (upcase guard))
         (insert "\n#define " (upcase guard))
         (insert "\n\n#endif")
         (insert " /* " (upcase guard) " */")
         (forward-line -1))
  )

(defun ins-extern-cpp ()
  "Insert extern cplusplus."
  (interactive)
  (progn (insert "#ifdef __cplusplus")
         (insert "\nextern \"C\" {")
         (insert "\n#endif")
         (insert "\n\n\n#ifdef __cplusplus")
         (insert "\n}\n#endif")
         (forward-line -3))
  )

(defun ins-namespace (namespace)
  "Insert namespace as NAMESPACE."
  (interactive "sEnter namespace:")
  (progn (insert (concat "namespace " namespace "{"))
         (insert "\n\n\n\n")
         (insert (concat "} // namespace " namespace))
         (forward-line -2)))

(provide '19_c++_minimal)

;;; End:

;;; 19_c++_minimal ends here
