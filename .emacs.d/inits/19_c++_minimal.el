;;; 19_c++_minimal.el --- settings for c++

;;; Commentary:
;;

;;; Code:

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))

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

(require 'use-package)
(use-package clang-format+)
(add-hook 'c-mode-common-hook #'clang-format+-mode)

;; https://blog.medalotte.net/archives/473

;; to run clang-format automatically
;; write ((c++-mode . ((mode . clang-format+))))
;; to .dir-locals.el
;; https://qiita.com/kari_tech/items/4754fac39504dccfd7be
(add-hook 'c++-mode-hook 'company-mode) ; 補完用
(add-hook 'c++-mode-hook 'flycheck-mode) ; チェック用
(add-hook 'c++-mode-hook #'lsp)

;; https://granddaifuku.hatenablog.com/entry/emacs-eglot

;; https://blog.medalotte.net/archives/473
(use-package ccls
  :custom
  (ccls-executable "ccls")
  (ccls-sem-highlight-method 'font-lock)
  (ccls-use-default-rainbow-sem-highlight)
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))

(provide '19_c++_minimal)

;;; End:

;;; 19_c++_minimal ends here
