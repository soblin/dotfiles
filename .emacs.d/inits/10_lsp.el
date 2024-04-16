;;; 10_lsp.el --- LSP settings

;;; Commentary:
;;

;;; Code:

(require 'company)
(bind-key "C-h" nil company-active-map)
(bind-key "C-n" 'company-select-next company-active-map)
(bind-key "C-p" 'company-select-previous company-active-map)
(bind-key "C-n" 'company-select-next company-search-map)
(bind-key "C-p" 'company-select-previous company-search-map)
;; (bind-key "<tab>" 'company-complete-common-or-cycle company-active-map)
;; (bind-key "<backtab>" 'company-select-previous company-active-map)
;; (bind-key "C-i" 'company-complete-selection company-active-map)
(bind-key "M-d" 'company-show-doc-buffer company-active-map)
(add-hook 'after-init-hook 'global-company-mode)

;; https://emacs.stackexchange.com/questions/20485/how-to-exclude-a-company-backend-from-autocompleting-without-globally-removing-i
;; clang failed with error:と出て遅くなるので
;; https://joppot.info/posts/2f73397f-e45e-4db5-9411-7563956f5375
(use-package company
  :ensure t
  ;; https://emacs.stackexchange.com/questions/32467/how-can-i-configure-company-mode-to-only-display-candidates-after-an-explicit-ke
  ;; いちいちidleが発生してノロいのでCtrl-iを押したときだけ候補一覧を出すようにした
  :bind (("<tab>" . company-complete)
         )
  :config
  (setq company-minimum-prefix-length 2)         ;; 補完できそうな文字が2文字以上入力されたら候補を表示
  (setq company-idle-delay nil)
  (setq company-tooltip-maximum-width 100)
  (setq company-selection-wrap-around t)
  (setq company-backends nil)
)


;; company-quickhelp
(setq company-quickhelp-color-foreground "white")
(setq company-quickhelp-color-background "dark slate gray")
(setq company-quickhelp-max-lines 5)
(company-quickhelp-mode)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))
(setq exec-path-from-shell-check-startup-files nil)

;; dumb-jump
(dumb-jump-mode)
(setq dumb-jump-selector 'helm)

;; smart-jump
(smart-jump-setup-default-registers)

;; lspモードの外観改善
;; https://emacs-lsp.github.io/lsp-mode/tutorials/how-to-turn-off/
(setq lsp-lens-enable nil)
(setq lsp-ui-doc-show-with-mouse nil)
(setq lsp-headerline-breadcrumb-enable nil)
(setq lsp-ui-sideline-enable nil)

;; https://ymtdzzz.dev/post/emacs-lsp-mode-more-faster/
(setq read-process-output-max (* 10 1024 1024)) ;; 10mb
(setq gc-cons-threshold 51200000)
(setq lsp-idle-delay 0.1)
(setq lsp-log-io nil) ; if set to true can cause a performance hit

;; https://emacs.stackexchange.com/questions/65123/company-completion-backend-company-capf-error-error
;; これを設定しないと補間を選択するとシンボルが$0に置き換わってしまう
(yas-global-mode)

;;; End:

;;; 10_lsp ends here
