;;; 99_c_cpp.el --- <Summary> -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;;; - https://github.com/emacs-lsp/lsp-mode/issues/1223
(use-package lsp-mode
  :hook ((c-mode c++-mode) . lsp)

  :config
  ;;; languages
  ;;; C++
  ;;; `-background-index` requires clangd v8+
  (setopt lsp-clients-clangd-args '("--background-index" "-log=error" "--clang-tidy" "--header-insertion=never"))

;;; for connecting to lsp-server inside docker
;;; - https://coder.com/docs/user-guides/workspace-access/emacs-tramp#language-servers-code-completion
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection "clangd")
                    :major-modes '(c++-mode)
                    :remote? t
                    :server-id 'clangd-remote))
  )


(defun my-clang-format-setup ()
  (setq-local
   clang-format-executable
   (or
    (and (file-remote-p default-directory)
         (let ((default-directory default-directory))
           (executable-find "clang-format")))
    (executable-find "clang-format")
    "clang-format")))

(use-package clang-format+
  :init
  (add-hook 'c-mode-common-hook #'clang-format+-mode)
  (add-hook 'c-mode-common-hook #'my-clang-format-setup)
  )
(require 'clang-format-remote)
(setq clang-format-remote-executable "clang-format")

(use-package cmake-mode
  :init
  )

(provide '99_c_cpp)
;;; 99_c_cpp.el ends here
