;;; 99_web.el --- <Summary> -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package web-mode
  :init

  :config
  (web-mode-markup-indent-offset 4)
  (web-mode-enable-auto-pairing t)
  (web-mode-enable-auto-closing t)
  )


(use-package nxml-mode
  :ensure nil ;; builtin

  :config
  (auto-fill-mode-hook -1)
  (nxml-slash-auto-complete-flag t)
  (nxml-child-indent 2)
  (nxml-attribute-indent 4)
  (indent-tabs-mode t)
  (nxml-bind-meta-tab-to-complete-flag t)
  (tab-width 4)
  )


(use-package typescript-mode
  :init

  :config
  (typescript-indent-level 2)
  )


(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (typescript-mode . lsp-deferred)
  )

(provide '99_web)
;;; 99_web.el ends here
