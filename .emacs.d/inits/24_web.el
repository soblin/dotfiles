;;; 24_web.el --- settings for html, css, js, xml, yaml, etc.

;;; Commentary:

;;; Code:
;;**********  settings for js **********

;; web-mode setting
(require 'web-mode)
(require 'nxml-mode)

(add-hook 'web-mode-hook
          (lambda ()
            (setq web-mode-markup-indent-offset 4)
            (setq web-mode-enable-auto-pairing t)
            (setq web-mode-enable-auto-closing t)
            )
          )

(add-to-list 'auto-mode-alist '("\\.html?$" . web-mode))

(add-to-list 'auto-mode-alist '("\\.urdf" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xacro" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.launch" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.launch.py" . python-mode))
(add-to-list 'auto-mode-alist '("\\.yaml" . yaml-mode))
(add-hook 'yaml-mode-hook 'highlight-indent-guides-mode)

(add-hook 'nxml-mode-hook
          (lambda()
            (setq auto-fill-mode-hook -1)
            (setq nxml-slash-auto-complete-flag t)
            (setq nxml-child-indent 2)
            (setq nxml-attribute-indent 4)
            (setq indent-tabs-mode t)
            (setq nxml-bind-meta-tab-to-complete-flag t)
            (setq tab-width 4))
          )

(add-to-list 'auto-mode-alist '("\\.ts[x]?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ts[x]?\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.js[x]?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'web-mode-hook 'lsp)

(require 'typescript-mode)
(add-hook 'typescript-mode-hook '(lambda () (setq typescript-indent-level 2)))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (typescript-mode . lsp-deferred))

(provide '24_web)
;;; End:

;;; 24_web ends here
