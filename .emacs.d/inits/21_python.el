;;; 21_python.el --- settings for python

;;; Commentary:
;;

;;; Code:

(require 'python)
(setq auto-mode-alist (cons '("\\.py\\'" . python-mode) auto-mode-alist))
(add-hook 'python-mode-hook
          (lambda ()
            (define-key python-mode-map (kbd "\C-m") 'newline-and-indent)
            (define-key python-mode-map (kbd "RET") 'newline-and-indent)))
;; (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

(add-hook 'python-mode-hook 'eglot-ensure)

(add-hook 'python-mode-hook 'blacken-mode)

;; https://tam5917.hatenablog.com/entry/20
(use-package blacken
  :delight
  :hook (python-mode . blacken-mode)
  :custom (blacken-line-length 79))

(use-package lsp-pyright
  :if (executable-find "pyright")
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))

(add-hook 'python-mode-hook
          (lambda ()
             (add-hook 'before-save-hook 'py-isort-before-save)))

(provide '21_python)

;;; End:

;;; 21_python ends here
