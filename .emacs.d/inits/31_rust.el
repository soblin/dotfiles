;;; 31_rust.el --- settings for Rust

;;; Commentary:
;;

;;; Code:

(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

(setq rust-format-on-save t)

;; (add-hook 'rust-mode-hook 'eglot-ensure)
;; eglot does not support rust-analyzer, so use lsp-mode
;; https://rust-analyzer.github.io/manual.html#lsp-mode
;; install rust-analyzer: https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary
(add-hook 'rust-mode-hook 'lsp-deferred)

;;; End:

;;; 31_rust ends here
