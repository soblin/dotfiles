;;; 00_basis.el --- basic settings

;;; Commentary:
;;

;;; Code:

;; japanese settings
;; (set-fontset-font t 'japanese-jisx0208 "TakaoPGothic")
;;(add-to-list 'face-font-rescale-alist '(".*Takao P.*" . 0.9)) ; OK

;; firacodeをaptで入れた
;; https://ybiquitous.me/blog/2022/try-fira-code-font

;; doom-themeの方で設定
;; (global-display-line-numbers-mode)

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

;; highlight-indent-guides
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-responsive 'top)

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
(add-hook 'after-save-hook
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

;;; smooth-scroll
(require 'smooth-scroll)
(smooth-scroll-mode t)

(defalias 'yes-or-no-p 'y-or-n-p)

(require 'helm)

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(add-hook 'helm-minibuffer-set-up-hook
          'spacemacs//helm-hide-minibuffer-maybe)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)

(helm-mode 1)

;;; https://github.com/ch11ng/exwm/issues/760 // cspell:disable-line
;;; "Wrong type argument: frame-live-p, #dead frame"で落ちるのを防ぐ
;; Add advice to stop hangs on EXWM // cspell:disable-line
;; The problem happens with floating windows that disappear - like open file dialog or a Zoom dialog when starting a meeting
;; The solution is to assure all frames in winner-modified-list pass the frame-live-p test
(defun gjg/winner-clean-up-modified-list ()
  "Remove dead frames from `winner-modified-list`"
  (dolist (frame winner-modified-list)
    (unless (frame-live-p frame)
      (delete frame winner-modified-list))))
(advice-add 'winner-save-old-configurations :before #'gjg/winner-clean-up-modified-list)

;; https://www.reddit.com/r/emacs/comments/l42oep/suppress_nativecomp_warnings_buffer/
(setq warning-minimum-level :error)

;; ROSのinstall/shareみたいなGit管理化のsymlinkに飛ぶ際にyes/noを訊かない
;; https://stackoverflow.com/questions/15390178/emacs-and-symbolic-links
(setq vc-follow-symlinks t)

;;; End:

;;; 00_basis ends here
