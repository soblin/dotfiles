;;; 30_tabbar.el --- tabbar settings

;;; Commentary:
;;

;;; Code:

;; Tabbar
(require 'tabbar)

(set-face-attribute
 'tabbar-unselected nil
 :background "#44475a"
 :foreground "white"
 :height 1.1
 :box '(:line-width 5 :color "#44475a" :style nil)
 )
(set-face-attribute
 'tabbar-selected nil
 :background "light sky blue"
 :foreground "black"
 :height 1.35
 :box '(:line-width 5 :color "light sky blue" :style nil)
 )

;; Change padding of the tabs
;; we also need to set separator to avoid overlapping tabs by highlighted tabs
(custom-set-variables
 '(tabbar-separator (quote (0.5))))
;; adding spaces
(defun tabbar-buffer-tab-label (tab)
  "Return a label for TAB.
That is, a string used to represent it on the tab bar."
  (let ((label  (if tabbar--buffer-show-groups
                    (format "[%s]  " (tabbar-tab-tabset tab))
                  (format "%s  " (tabbar-tab-value tab)))))
    ;; Unless the tab bar auto scrolls to keep the selected tab
    ;; visible, shorten the tab label to keep as many tabs as possible
    ;; in the visible area of the tab bar.
    (if tabbar-auto-scroll-flag
        label
      (tabbar-shorten
       label (max 1 (/ (window-width)
                       (length (tabbar-view
                                (tabbar-current-tabset)))))))))

(setq tabbar-buffer-groups-function nil)
;; ウインドウからはみ出たタブを省略して表示
(setq tabbar-auto-scroll-flag nil)
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))

(define-key global-map (kbd "C-x C-n") 'tabbar-backward-tab)
(define-key global-map (kbd "C-x C-p") 'tabbar-forward-tab)

(defun my-tabbar-buffer-list ()
  (cons "*scratch*" ;; scratchは残す
        (remove-if (lambda (buffer) (or (cl-search "*" (buffer-name buffer)) ;; *を含むやつ
                                        (cl-search "magit" (buffer-name buffer)) ;; magitを含むやつ
                                        (cl-search "markdown-code-fontification" (buffer-name buffer))
                                        ))
                   (buffer-list)
                   )
        )
  )

(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)

(tabbar-mode 1)
;;; End:

;;; 30_tabbar ends here
