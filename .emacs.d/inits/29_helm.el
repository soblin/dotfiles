(require 'helm)
;;(helm-migemo-mode 1)

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))


(add-hook 'helm-minibuffer-set-up-hook
          'spacemacs//helm-hide-minibuffer-maybe)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)

(when (require 'helm-c-moccur nil t)
  (setq
   helm-idle-delay 0.1
   helm-c-moccur-helm-idle-delay 0.1
   helm-c-moccur-higligt-info-line-flag t
   helm-c-moccur-enable-auto-look-flag t
   helm-c-moccur-enable-initial-pattern t
   )
  (global-set-key (kbd "C-M-o") 'helm-c-moccur-occur-by-moccur)
  )

(helm-autoresize-mode 1)

(helm-mode 1)
