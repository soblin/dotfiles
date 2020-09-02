;;; 24_web.el --- settings for html, css, js, xml, yaml, etc.

;;; Commentary:

;;; Code:
(setq web-mode-auto-close-style 1)
(setq web-mode-tag-auto-close-style t)

;;**********  settings for js **********
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(setq web-mode-auto-close-style 2)

;; web-mode setting
(require 'nxml-mode)

(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

(add-to-list 'auto-mode-alist '("\\.urdf" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xacro" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.launch" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml" . yaml-mode))

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

(provide '24_web)
;;; End:

;;; 24_web ends here
