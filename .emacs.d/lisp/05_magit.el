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

(defun github (&optional remote)
  "Open the current file and line on GitHub.
With REMOTE, use the repository that remote points to."
  (interactive
   (list (let ((r (completing-read "Remote (default: gh default): "
                                   (magit-list-remotes) nil t)))
           (unless (string-empty-p r) r))))
  (let* ((file (buffer-file-name))
         (line (line-number-at-pos))
         (rel (file-relative-name file (vc-root-dir)))
         (branch (or (magit-get-current-branch) "main"))
         (remote-url (and remote (magit-get "remote" remote "url")))
         (repo (and remote-url
                    (string-match
                     "github\\.com[:/]\\([^/]+/[^/]+?\\)\\(?:\\.git\\)?/?\\'"
                     remote-url)
                    (match-string 1 remote-url)))
         (url (progn
                (when (and remote (not repo))
                  (user-error "Cannot resolve GitHub repo for remote: %s" remote))
                (string-trim
                 (shell-command-to-string
                  (format "gh browse /%s:%d --branch %s %s--no-browser"
                          rel line (shell-quote-argument branch)
                          (if repo (format "-R %s " (shell-quote-argument repo)) "")))))))
    (browse-url url)))


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
