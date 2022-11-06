;;; 00_basis.el --- basic settings

;;; Commentary:
;;

;;; Code:

;; japanese settings
(set-fontset-font t 'japanese-jisx0208 "TakaoPGothic")
(add-to-list 'face-font-rescale-alist '(".*Takao P.*" . 0.9)) ; OK

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

;; ファイル検索で大文字と小文字を区別しない
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;; shebangで始まるファイルを、実行可能にして保存する
(add-hook 'after-save-hool
          'executable-make-buffer-file-executable-if-script-p)

(add-to-list 'exec-path "/usr/bin")
(add-to-list 'exec-path "/usr/local/bin")

(cua-mode t)
(setq cua-enable-cua-keys nil)

(blink-cursor-mode 0)

(require 'undo-tree)
(global-undo-tree-mode)

;;; https://emacs.stackexchange.com/questions/51410/saving-undo-tree-to-restore-in-next-session
(setq undo-tree-auto-save-history nil)

;;; https://qiita.com/ongaeshi/items/696407fc6c42072add54
(setq ring-bell-function 'ignore)

;;; https://www.grugrut.net/posts/202104262248/
(custom-set-variables '(warning-suppress-types '((comp))))

;;; End:

;;; 00_basis ends here
