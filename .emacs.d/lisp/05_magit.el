;;; 05_magit.el --- git setting -*- lexical-binding: t; -*-

;;; Commentary:
;;; - https://qiita.com/nobuyuki86/items/122e85b470b361ded0b4
;;; - https://qiita.com/nobuyuki86/items/e392b642189d755dd113

;;; Code:

(use-package magit
  :config
  (require 'magit-extras))

(use-package forge
  :after magit
  )

(defun github()
  (interactive)
  (let* ((file (buffer-file-name))
         (line (line-number-at-pos))
         (rel (file-relative-name file (vc-root-dir)))
         (url (shell-command-to-string
               (format "gh browse /%s:%d --no-browser" rel line)
               )
              )
         )
    (browse-url url)
    )
  )


;; visualize not committed part
(use-package diff-hl
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :init
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (global-diff-hl-mode)
  (diff-hl-margin-mode))


;; difftastic
(use-package difftastic
  :config
  (difftastic-bindings-mode))
(provide '05_magit)
;;; 05_magit.el ends here
