;;; 07_tramp.el --- <Summary> -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;;; https://www.reddit.com/r/emacs/comments/15urfgh/how_to_make_my_remote_tramp_use_usrbinenv_bash/
(use-package tramp
  :straight (:type built-in)
  :defer t
  :custom
  ;; https://emacs.stackexchange.com/questions/37190/remote-shell-path-env-no-such-file-or-directory
  (tramp-default-remote-shell "/bin/bash")

  ;; https://www.reddit.com/r/emacs/comments/xicolr/emacs_does_not_load_dirlocalsel/?tl=ja
  ;; https://robbmann.io/emacsd/
  ;; (setq enable-remote-dir-locals t)
  :config

  ;; https://robbmann.io/emacsd/
  (setq vc-handled-backends '(Git)
        file-name-inhibit-locks t
        tramp-inline-compress-start-size 1000
        tramp-copy-size-limit 10000
        tramp-verbose 1)
  (setq tramp-use-ssh-controlmaster-options nil)

  ;; https://achiwa912.github.io/tramp.html#orgc8ba9ef
  (with-eval-after-load 'tramp
    (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
    )
  )


(defun start-file-process-shell-command@around (start-file-process-shell-command name buffer &rest args)
  "Start a program in a subprocess.  Return the process object for it.
Similar to `start-process-shell-command', but calls `start-file-process'."
  ;; On remote hosts, the local `shell-file-name' might be useless.
  (let ((command (mapconcat 'identity args " ")))
    (funcall start-file-process-shell-command name buffer command)))

(advice-add 'start-file-process-shell-command :around #'start-file-process-shell-command@around)
;;; https://robbmann.io/emacsd/

(provide '07_tramp)
;;; 07_tramp.el ends here
