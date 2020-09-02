;;; 28_julia.el --- settings for reStructured Text

;;; Commentary:
;;

;;; Code:
(add-to-list 'load-path "~/dotfiles/.emacs.d/elpa/julia-emacs")
(require 'julia-mode)

(setq auto-mode-alist
      (append '(("\\.jl$" . julia-mode)) auto-mode-alist))

(provide '28_julia)
;;; End:
;;; 28_julia ends here
