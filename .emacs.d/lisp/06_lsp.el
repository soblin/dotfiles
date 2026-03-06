;;; 06_lsp.el --- <Summary> -*- lexical-binding: t; -*-

;;; Commentary:
;;; - https://qiita.com/nobuyuki86/items/122e85b470b361ded0b4#jsonrpc

;;; Code:

;;; lsp
;;; - https://github.com/emacs-lsp/lsp-mode/issues/1223
(use-package lsp-mode
  :hook ((c-mode c++-mode) . lsp)
  :init
  (setopt lsp-headerline-breadcrumb-enable nil)

  :config
  ;; `-background-index` requires clangd v8+
  (setq lsp-clients-clangd-args '("--background-index" "-log=error" "--clang-tidy" "--header-insertion=never"))
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-lens-enable nil)
  (setq lsp-log-io nil)
  (setq lsp-idle-delay 0.1)
  (setq lsp-signature-auto-activate t)
  (setq lsp-completion-provider :capf)
  (setq lsp-enable-snippet t)

  ;; not tested
  (setq lsp-prefer-flymake nil)
  (setq lsp-eldoc-hook nil)
  )

(use-package yasnippet)
(yas-global-mode 1)

(use-package yasnippet-capf
  :ensure t
  :after yasnippet
  :config
  ;; Add the yasnippet-capf function to the list of completion functions
  (add-to-list 'completion-at-point-functions #'yasnippet-capf)
  )

(use-package jsonrpc
  :config
  (setq jsonrpc-default-request-timeout 3000)
  (fset #'jsonrpc--log-event #'ignore))


(use-package corfu
  :ensure t
  :init
  (global-corfu-mode 1)
  :config
  ;;; it seems this is not required and I could insert with C-M-i without this,
  ;;; but many site do this
  ;;; - https://qiita.com/nobuyuki86/items/7c65456ad07b555dd67d
)

(provide '06_lsp)
;;; 06_lsp.ends here
