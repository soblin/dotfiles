;;; 01_global_keybindings.el --- basic keybinding setting -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package consult
  :ensure t
  :custom
  (consult-ripgrep-args
   "rg --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --with-filename --line-number --search-zip --hidden --glob=!.git/"
   )
  )
(use-package visual-regexp)
(require 'visual-regexp)

;;; C-h for "Backspace"
;;; change C-h to C-? for "help"
(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key (kbd "C-h") 'delete-backward-char)


;;; delete all chars on current line like terminal
(global-unset-key (kbd "C-u"))
(global-set-key (kbd "C-u")
                (lambda () (interactive)(progn (beginning-of-line)(kill-line)))
                )


;;; consult
;;; find-grep-dired
(defun consult-ripgrep-current-directory ()
  (interactive)
  (consult-ripgrep default-directory))
(global-set-key (kbd "C-c C-g") 'consult-ripgrep-current-directory)

(global-set-key (kbd "C-c C-s") 'consult-line)
(defun my/remap-c-show-syntactic-information ()
    (global-set-key [remap c-show-syntactic-information] 'consult-line))
(add-hook 'c-mode-common-hook #'my/remap-c-show-syntactic-information)

(define-minor-mode my-override-mode
  "Override keybindings."
  :global t
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c C-b") #'consult-buffer)
            map))
(my-override-mode 1)

;;; goto-line
(global-set-key (kbd "M-g") 'consult-goto-line)


;;; undo
(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode t)
  :bind (("C-x C-u" . undo))
  :custom
  (undo-tree-auto-save-history nil)
  )


;;; selection
(global-unset-key (kbd "C-\\"))
(global-set-key (kbd "C-\\") 'set-mark-command)


;;; replace
(global-set-key (kbd "M-%") 'vr/query-replace)


;;; paste from system clipboard
(cua-mode t)
(setq cua-enable-cua-keys nil)
(define-key global-map (kbd "C-S-v") 'cua-paste)


;; yank
(global-unset-key (kbd "C-y"))
(global-set-key (kbd "C-y") 'consult-yank-pop)


;;; zoom-in/zoom-out
(load-file (expand-file-name "site-lisp/zoom-frm.el" user-emacs-directory))
(global-set-key (kbd "C-+") 'zoom-all-frames-in)
(global-set-key (kbd "C--") 'zoom-all-frames-out)


;;; change window by C-t
(global-set-key (kbd "C-t") 'other-window)


;;; kill buffer
(global-set-key (kbd "C-x C-k") 'kill-buffer)


;; tab
(global-set-key (kbd "C-x C-n") 'centaur-tabs-backward)
(global-set-key (kbd "C-x C-p") 'centaur-tabs-forward)


;; unset
(global-unset-key (kbd "C-x m"))
(global-unset-key (kbd "C-j"))

(provide '01_global_keybindings)
;;; 01_global_keybindings.el ends here
