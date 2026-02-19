;;; 02_doom.el --- basic settings

;;; Commentary:
;;

;;; Code:

;; default-theme
;; (load-theme 'dracula t)

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-dracula t)
  (doom-themes-neotree-config)
  )

;; https://qiita.com/Ladicle/items/feb5f9dce9adf89652cf
(use-package doom-modeline
  :custom
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon nil)
  (doom-modeline-minor-modes nil)
  :hook
  (after-init . doom-modeline-mode)
  :config
  (line-number-mode 1)
  (column-number-mode 1))

;; https://github.com/seagle0128/doom-modeline#use-package
(setq doom-modeline-icon t)
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-major-mode-color-icon t)
(setq doom-modeline-buffer-state-icon t)
(setq doom-modeline-buffer-modification-icon t)
(setq doom-modeline-time-icon t)
(setq doom-modeline-unicode-fallback nil)
(setq doom-modeline-buffer-name t)
(setq doom-modeline-lsp t)

(nyan-mode 1)

(tab-bar-mode 1)

;; -nwオプションで動作していたら背景をterminalに合わせる
(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))
(add-hook 'window-setup-hook #'on-after-init)

(defun on-frame-open (&optional frame)
  "If the FRAME created in terminal don't load background color."
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)))
(add-hook 'after-make-frame-functions #'on-frame-open)

;;; End:

;;; 02_doom ends here
