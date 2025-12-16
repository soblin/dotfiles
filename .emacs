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
   '(all-the-icons bind-key blacken ccls clang-format clang-format+
                   cmake-mode company company-quickhelp consult-gh
                   dap-mode doom-modeline doom-themes dracula-theme
                   dumb-jump ein exec-path-from-shell fish-mode
                   flycheck flycheck-clang-tidy forge go-mode helm
                   helm-migemo highlight-indent-guides html5-schema
                   init-loader jedi js2-mode js2-modeyasnippet
                   json-mode ligature lsp-pyright lsp-ui magit
                   markdown-mode markdown-mode+ markdown-preview-mode
                   matlab-mode neotree nyan-mode package-utils
                   py-autopep8 py-isort python-isort pyvenv
                   restart-emacs smart-jump smartrep smooth-scroll
                   sphinx-mode sudo-edit tabbar typescript-mode
                   undo-tree use-package visual-regexp web-mode
                   yaml-mode yasnippet yatex zoom-frm))
 '(safe-local-variable-values '((cmake-tab-width . 4)))
 '(tab-bar-mode t)
 '(tabbar-separator '(0.5))
 '(visible-bell nil)
 '(warning-suppress-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Fira Code" :foundry "CTDB" :slant normal :weight regular :height 102 :width normal))))
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
 '(font-lock-comment-face ((t (:foreground "dark gray"))))
 '(tab-bar-tab-group-current ((t (:inherit tab-bar-tab :box nil :weight bold :height 1.1))))
 '(tab-bar-tab-group-inactive ((t (:inherit (shadow tab-bar-tab-inactive) :height 1.1))))
 '(tab-bar-tab-ungrouped ((t (:inherit (shadow tab-bar-tab-inactive) :height 1.1)))))
;;; .emacs ends here
