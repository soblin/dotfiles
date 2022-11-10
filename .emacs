;;; package --- Summary
;;; Commentary:
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;; Code:
(package-initialize)

;; init-loader settings

(require 'package)
;; add MELPA
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(require 'init-loader)

;; not display log of init-loader
(setq init-loader-show-log-after-init nil)

(init-loader-load "~/.emacs.d/inits")

;; System settings

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(global-display-line-numbers-mode t)
 '(highlight-indent-guides-method 'column)
 '(package-selected-packages
   '(highlight-indent-guides neotree nyan-mode all-the-icons doom-modeline doom-themes fish-mode dumb-jump exec-path-from-shell smart-jump company-quickhelp eglot ccls use-package clang-format+ clang-format magit undo-tree visual-regexp tabbar helm-migemo markdown-preview-mode zoom-frm go-mode helm sphinx-mode markdown-mode+ py-autopep8 jedi markdown-mode matlab-mode sudo-edit restart-emacs yatex js2-mode dracula-theme yaml-mode json-mode html5-schema web-mode js2-modeyasnippet cmake-mode company package-utils init-loader bind-key))
 '(safe-local-variable-values '((cmake-tab-width . 4)))
 '(show-paren-mode t)
 '(tabbar-separator '(0.5))
 '(visible-bell nil)
 '(warning-suppress-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "DAMA" :slant normal :weight normal :height 132 :width normal))))
 '(YaTeX-font-lock-crossref-face ((t (:foreground "dark orange"))))
 '(YaTeX-font-lock-declaration-face ((t (:foreground "hot pink"))))
 '(YaTeX-font-lock-delimiter-face ((t (:background "dark magenta" :foreground "lightyellow3" :weight bold))))
 '(YaTeX-font-lock-formula-face ((t (:foreground "deep sky blue" :weight bold))))
 '(YaTeX-font-lock-label-face ((t (:foreground "gold"))))
 '(YaTeX-font-lock-math-sub-face ((t (:foreground "white" :underline t :weight bold))))
 '(YaTeX-font-lock-math-sup-face ((t (:foreground "ivory" :underline t :weight normal))))
 '(YaTeX-sectioning-1 ((t (:foreground "#f9f900" :underline t :slant italic))))
 '(YaTeX-sectioning-2 ((t (:foreground "#f3f300" :underline t :slant italic))))
 '(YaTeX-sectioning-3 ((t (:foreground "#ecec00" :underline t :slant italic))))
 '(YaTeX-sectioning-4 ((t (:foreground "#e6e600" :underline t :slant italic))))
 '(font-lock-comment-face ((t (:foreground "green yellow"))))
 '(font-lock-doc-face ((t (:foreground "dark orange"))))
 '(font-lock-preprocessor-face ((t (:inherit font-lock-builtin-face :slant italic))))
 '(font-lock-string-face ((t (:foreground "dark orange"))))
 '(tab-bar-tab ((t (:background "DeepPink3" :foreground "#f8f8f2" :box nil :height 1.3))))
 '(tab-bar-tab-group-current ((t (:inherit tab-bar-tab :box nil :weight bold :height 1.1))))
 '(tab-bar-tab-group-inactive ((t (:inherit (shadow tab-bar-tab-inactive) :height 1.1))))
 '(tab-bar-tab-inactive ((t (:inherit tab-line-tab :background "#1E2029" :foreground "#e2e2dc" :box nil :height 1.3))))
 '(tab-bar-tab-ungrouped ((t (:inherit (shadow tab-bar-tab-inactive) :height 1.1))))
 '(tab-line ((t (:background "#1E2029" :foreground "#1E2029" :box nil :height 1.1))))
 '(tabbar-selected ((t (:inherit tabbar-default :background "DodgerBlue3" :foreground "#f8f8f2" :weight bold)))))
;;; .emacs ends here
