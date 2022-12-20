;;; 01_key.el --- basic settings

;;; Commentary:
;;

;;; Code:

;; "C-h"でbackspaceするため
(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key "\C-h" 'delete-backward-char)
;; "C-x u"するとundo-treeを出す．"C-x C-u"すると単純に前に戻る
(define-key global-map (kbd "C-x C-u") 'undo)

;; "C-\\"で範囲選択を開始
(global-unset-key (kbd "C-\\"))
(define-key global-map (kbd "C-\\") 'set-mark-command)

;; "C-k"でその行を一気に消す
(defun my-delete-line ()
  (interactive)
  (progn (beginning-of-line)
         (kill-line)
         ))
(define-key global-map (kbd "C-k") 'my-delete-line)

;; バッファを閉じる
(define-key global-map (kbd "C-x C-k") 'kill-buffer)

(global-set-key (kbd "M-%") 'vr/query-replace)

(global-unset-key (kbd "C-x m"))
(global-unset-key (kbd "C-j"))

;; emacs全体でのzoom in/out
(load-file "~/.emacs.d/elpa/frame-fns/frame-fns.el")
(load-file "~/.emacs.d/elpa/frame-cmds/frame-cmds.el")
(load-file "~/.emacs.d/elpa/zoom-frm/zoom-frm.el")
(define-key global-map (kbd "C-x C-+") 'zoom-all-frames-in)
(define-key global-map (kbd "C-x C--") 'zoom-all-frames-out)

;; コピペ
(define-key global-map (kbd "C-S-v") 'cua-paste)

;; (define-key global-map (kbd "-w") 'copy-region-as-kill)

;; Helm
;; https://qiita.com/jabberwocky0139/items/86df1d3108e147c69e2c
(global-unset-key (kbd "C-x c"))

(global-set-key (kbd "M-x") 'helm-M-x)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(global-set-key (kbd "C-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

;;; End:

;;; 01_key ends here
