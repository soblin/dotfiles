;;; 99_rust.el --- <Summary> -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package rust-mode
  :ensure t
  :custom rust-format-on-save t)


(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode))


(use-package lsp-mode
  :hook (rust-mode . lsp)

  :config
;;; for connecting to lsp-server inside docker
;;; - https://coder.com/docs/user-guides/workspace-access/emacs-tramp#language-servers-code-completion
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection "rust-analyzer")
                    :major-modes '(rust-mode)
                    :remote? t
                    :server-id 'rust-analyzer-remote))
  )

(provide '99_rust)
;;; 99_rust.el ends here
