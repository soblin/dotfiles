;;; 02_doom.el --- basic settings

;;; Commentary:
;;

;;; Code:

;; default-theme
;; (add-to-list 'load-path "~/.emacs.d/themes")
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;; (load-theme 'dracula t)

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-dracula t))

;; https://github.com/seagle0128/doom-modeline#use-package
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))
(require 'all-the-icons)

(setq doom-modeline-icon t)

(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-major-mode-color-icon t)
(setq doom-modeline-buffer-state-icon t)
(setq doom-modeline-buffer-modification-icon t)
(setq doom-modeline-time-icon t)
(setq doom-modeline-unicode-fallback nil)
(setq doom-modeline-buffer-name t)

;;; End:

;;; 02_doom ends here
