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
  )

(provide '06_lsp)
;;; 06_lsp.ends here
