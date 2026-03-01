;;; 06_lsp.el --- <Summary> -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package lsp-mode
  :hook ((c-mode c++-mode) . lsp)
  :init
  (setopt lsp-headerline-breadcrumb-enable nil)

  :config
  ;; `-background-index` requires clangd v8+
  (setq lsp-clients-clangd-args '("--background-index" "-log=error" "--clang-tidy" "--header-insertion=never"))
  (setq-default lsp-enable-on-type-formatting nil)
  )


(use-package consult-lsp
  :after lsp-mode
  :config
  (define-key lsp-mode-map [remap xref-find-apropos] #'consult-lsp-symbols))

(provide '06_lsp)
;;; 06_lsp.ends here
