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

;; (define-key global-map (kbd "-w") 'copy-region-as-kill)

;;; End:

;;; 01_key ends here
