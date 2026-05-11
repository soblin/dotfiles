;;; 99_python.el --- <Summary> -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;;; Emacsをvenv内から立ち上げる方針が楽

;; ruff serverは微妙
;; textDocument/definitionがサポートされておらず，ruff-lspを起動するよう上書きをしてもエラーが出た
;; (with-eval-after-load 'lsp-ruff
;;   (setq lsp-ruff-server-command '("ruff-lsp")))
;; pyrightを入れるのが楽
(use-package lsp-mode
  :hook (python-mode . lsp)
  :config
  )

(use-package lsp-pyright
  :if (executable-find "pyright")
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))

;; docker連携はTODO

(provide '99_python)
;;; 99_python.el ends here
