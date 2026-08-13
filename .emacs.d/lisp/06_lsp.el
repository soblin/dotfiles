;;; 06_lsp.el --- <Summary> -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;;; lsp
;;; - https://github.com/emacs-lsp/lsp-mode/issues/1223
(use-package lsp-mode
  :commands lsp
  :init
  (setopt lsp-headerline-breadcrumb-enable nil)

  :config
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-lens-enable nil)
  (setq lsp-log-io nil)
  (setq lsp-idle-delay 0.1)
  (setq lsp-completion-provider :none)
  )


(use-package lsp-ui
  :config
  (setq lsp-ui-peek-enable t)
  (setq lsp-ui-doc-show-with-mouse nil)
  (setq lsp-ui-doc-show-with-cursor t)

  ;; sideline diagnostic is visible in minibuffer, so not needed
  ;; https://emacs-lsp.github.io/lsp-mode/tutorials/how-to-turn-off/
  (setq lsp-ui-sideline-enable nil)
  (setq lsp-ui-sideline-show-diagnostics nil)
  )

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  )


;;; corfu
;;; - https://qiita.com/nobuyuki86/items/7c65456ad07b555dd67d
;;; - https://qiita.com/nobuyuki86/items/122e85b470b361ded0b4#jsonrpc
(use-package corfu
  :ensure t
  :straight
  (corfu :files (:defaults "extensions/*"))
  :init
  (global-corfu-mode 1)
  (corfu-popupinfo-mode 1)
  :config
  (setq corfu-cycle t)
  (setq corfu-quit-no-match t)
  (setq corfu-auto nil)
  (setq corfu-on-exact-match nil)
  (setq tab-always-indent 'complete)
  (setq corfu-popupinfo-delay '(0.5 . 1.0))

  :bind (nil
         :map corfu-map
         ("RET" . corfu-insert)
         ("<return>" . corfu-insert))
  )


(use-package jsonrpc
  :config
  (setq jsonrpc-default-request-timeout 3000)
  (fset #'jsonrpc--log-event #'ignore))

(use-package tabnine
  :hook ((prog-mode . tabnine-mode)
         (text-mode . tabnine-mode)
         (kill-emacs . tabnine-kill-process))
  :bind (:map  tabnine-completion-map
               ("TAB" . nil)
               ("<tab>" . nil))
  :init
  (tabnine-start-process)
  (global-tabnine-mode +1))

(use-package cape
  :hook (((prog-mode
           text-mode
           conf-mode
           eglot-managed-mode
           lsp-completion-mode) . my/set-super-capf))
  :config
  (defun my/set-super-capf (&optional arg)
    (setq-local completion-at-point-functions
                (list (cape-capf-noninterruptible
                       (cape-capf-buster
                        (cape-capf-properties
                         (cape-capf-super
                          (if arg
                              arg
                            (car completion-at-point-functions))
                          #'tabnine-completion-at-point)
                         :sort t
                         :exclusive 'no))))))

  (add-to-list 'completion-at-point-functions #'tabnine-completion-at-point)
  )

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides nil)

  :config
  (with-eval-after-load 'corfu
    (add-hook 'corfu-mode-hook
              (lambda ()
                (setq-local orderless-matching-styles '(orderless-flex)))))
  )

(use-package yasnippet
  :bind (nil
         :map yas-keymap
         ("<tab>" . yas-next-field-or-maybe-expand)
         ("TAB" . yas-next-field-or-maybe-expand)
         )
  :init
  (yas-global-mode +1))

(use-package kind-icon
  :after corfu
  :custom (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  )


(use-package corfu-terminal
  :init
  :config
  ;; NOTE: popupinfo still uses child frame, so doc for each candidate does not appear
  (unless (display-graphic-p) (corfu-terminal-mode t))
  )

(provide '06_lsp)
;;; 06_lsp.el ends here
