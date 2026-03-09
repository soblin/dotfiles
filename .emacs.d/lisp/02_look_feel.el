;;; 02_look_feel.el --- setting for look & feel -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;;; show menu-bar/tool-bar/scroll-bar
;;; - https://stackoverflow.com/questions/37490362/emacs-no-menubar-and-toolbar
(defun restore-menu-bar()
  (interactive)
  (if (fboundp 'scroll-bar-mode) (scroll-bar-mode 1))
  (if (fboundp 'tool-bar-mode) (tool-bar-mode 1))
  (if (fboundp 'menu-bar-mode) (menu-bar-mode 1)))
(restore-menu-bar)


;;; startup window
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)


;;; disable cursor blink
(blink-cursor-mode 0)


;;; line number
(global-display-line-numbers-mode t)
(column-number-mode t)


;;; current line
(use-package paren
  :init
  (show-paren-mode 1)
  :custom
  (setq show-paren-style 'expression)
  )

;;(use-package hl-line
;;  :init
;;  (global-hl-line-mode 1))


;;; parenthesis
(use-package elec-pair
  :config
  (electric-pair-mode 1))


;;; indent visualization
;;; - https://qiita.com/nobuyuki86/items/e392b642189d755dd113
(use-package highlight-indent-guides
  :ensure t
  :hook
  (prog-mode . highlight-indent-guides-mode)
  (docker-compose-mode . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-responsive 'top)
  (highlight-indent-guides-method 'column)
  (highlight-indent-guides-auto-add-odd-face-perc 10)
  (highlight-indent-guides-auto-add-odd-even-perc 10)
  :config
  (set-face-background 'highlight-indent-guides-odd-face "dimgray")
  (set-face-background 'highlight-indent-guides-even-face "dimgray")
  )


;;; show trailing whitespace
(setq-default show-trailing-whitespace t)


;;; disable beep sound
(setq ring-bell-function 'ignore)


;;; yes-or-no
(defalias 'yes-or-no-p 'y-or-n-p)


;; scroll
(use-package smooth-scroll)
(require 'smooth-scroll)
(smooth-scroll-mode t)
(setq scroll-conservatively 1)


;;; compact minor-mode
(use-package minions
  :init
  (minions-mode 1))

(provide '02_look_feel)
;;; 02_look_feel.el ends here
