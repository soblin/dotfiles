;;; 00_basis.el --- basic settings

;;; Commentary:
;;

;;; Code:

;; japanese settings
;; (set-fontset-font t 'japanese-jisx0208 "TakaoPGothic")
;; (add-to-list 'face-font-rescale-alist '(".*Takao P.*" . 0.9)) ; OK

;; default-theme
(add-to-list 'load-path "~/.emacs.d/themes")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;;(load-theme 'tomorrow-night-bright t)
;;(load-theme 'tomorrow-day t)
;;(require 'twilight-bright-theme)
(load-theme 'dracula t)

;; 左に行番号表示
;; (require 'linum)
;; (global-linum-mode)
(global-display-line-numbers-mode)
(set-face-attribute 'line-number nil
                    :foreground "#f8f8f2"
                    )
(set-face-attribute 'line-number-current-line nil
                    :background "gray29"
                    )

;; 行番号と列番号を表示する
(column-number-mode t)

;; 現在行をハイライト
(show-paren-mode t)
;; parenのスタイル expressionは括弧内も強調表示
(setq show-paren-style 'expression)
;;(set-face-background 'show-paren-match-face nil)
;; アンダーバー
;;(set-face-underline 'show-paren-match-face "magenta")

;; 括弧を補完
(electric-pair-mode 1)

;; 置換時に大文字、小文字をそのまま
(setq case-replace nil)

;; ホーム画面表示しない
(setq inhibit-startup-screen t)

;; scratch表示しない
(setq initial-scratch-message nil)

;; タブにスペースを表示する
(setq-default tab-width 4 indent-tabs-mode nil)

;; C-tでウィンドウを切り替える.
(define-key global-map (kbd "C-t") 'other-window)

;; タイトルバーにファイルのフルパスを表示
;; (setq frame-title-format "%f")

;; do not create .~ file
(setq make-backup-files nil)

;; 更新されたファイルを自動的に読みなおす
(global-auto-revert-mode t)

(setq scroll-conservatively 1)

(define-key key-translation-map [?\C-h] [?\C-?])

;; ファイル検索で大文字と小文字を区別しない
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

(define-key global-map (kbd "C-x C-u") 'undo)

(global-unset-key (kbd "C-\\"))

;; shebangで始まるファイルを、実行可能にして保存する
(add-hook 'after-save-hool
          'executable-make-buffer-file-executable-if-script-p)

(load-file "~/.emacs.d/elpa/frame-fns/frame-fns.el")
(load-file "~/.emacs.d/elpa/frame-cmds/frame-cmds.el")
(load-file "~/.emacs.d/elpa/zoom-frm/zoom-frm.el")

(define-key global-map (kbd "C-x C-+") 'zoom-all-frames-in)
(define-key global-map (kbd "C-x C--") 'zoom-all-frames-out)

(add-to-list 'exec-path "/usr/bin")
(add-to-list 'exec-path "/usr/local/bin")

(defun maker ()
  (interactive)
  (progn
    (async-shell-command "make -k")                      ; Publish the command
    (setq cur (selected-window))                         ; save the working buffer
    (setq w (get-buffer-window "*Async Shell Command*")) ; get height of *Async Shell Command* object
    (select-window w)                                    ; go to *Async Shell Command* 
    (setq h (window-height w))                           ; get its height
    (shrink-window (- h 6))                              ; shrink by the difference
    (select-window cur)                                  ; return to the working buffer
    )
  )

(global-set-key "\C-h" 'delete-backward-char)

(global-unset-key (kbd "C-x m"))

(global-unset-key (kbd "C-j"))

(defun my-delete-line ()
  (interactive)
  (progn (beginning-of-line)
         (kill-line)
         ))

(define-key global-map (kbd "C-k") 'my-delete-line)

(cua-mode t)
(setq cua-enable-cua-keys nil)

(define-key global-map (kbd "C-x C-k") 'kill-buffer)

(global-set-key (kbd "M-%") 'vr/query-replace)

(blink-cursor-mode 0)

(define-key global-map (kbd "C-\\") 'set-mark-command)

(require 'undo-tree)
(global-undo-tree-mode)

;; (define-key global-map (kbd "-w") 'copy-region-as-kill)

;;; End:

;;; 00_basis ends here
