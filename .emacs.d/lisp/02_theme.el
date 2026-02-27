;;; 02_theme.el --- setting for theme -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;;; theme

;;; NOTE: below doom-themes setting does not work in docker with `.emacs.d/` mounted and initialized on host, because if `.emacs.d/straight/build` is initialized, `.emacs.d/straight/build/doom-theme` is added to `custom-theme-load-path`, but the files are symlink on host, which are dead link in docker
;;; relevant: https://github.com/doomemacs/doomemacs/issues/6213
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-dracula t)
  (doom-themes-neotree-config)
  )

(use-package doom-modeline
  :custom
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-minor-modes t)
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-buffer-modification-icon t)
  (doom-modeline-time-icon t)
  (doom-modeline-unicode-fallback nil)
  (doom-modeline-buffer-name t)
  (doom-modeline-lsp t)
  :hook
  (after-init . doom-modeline-mode)
  :config
  (line-number-mode 1)
  (column-number-mode 1))


;;; nyan-mode
(use-package nyan-mode)
(nyan-mode 1)

(provide '02_theme)
;;; 02_theme.el ends here
