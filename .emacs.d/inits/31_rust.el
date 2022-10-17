;;; 31_rust.el --- settings for Rust

;;; Commentary:
;;

;;; Code:

(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

(setq rust-format-on-save t)

(add-hook 'rust-mode-hook 'eglot-ensure)

;;; End:

;;; 31_rust ends here
