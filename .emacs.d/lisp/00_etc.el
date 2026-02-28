;;; 00_etc.el --- etc setting -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


;;; do not create .~ file
(setq make-backup-files nil)


;;; reflect file edition on other buffer
(use-package autorevert
  :init
  (global-auto-revert-mode +1))


;;; do not as yes/not for git-controlled symlink ?
;;; - https://stackoverflow.com/questions/15390178/emacs-and-symbolic-links
(setq vc-follow-symlinks t)


;;; do not care capital/small letter for regex
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)


;;; keep capital/small letter in regex replace
(setq case-replace nil)


;;; disable native-comp warnings
;;; - https://www.grugrut.net/posts/202104262248/
;;; - https://www.reddit.com/r/emacs/comments/l42oep/suppress_nativecomp_warnings_buffer/
(setq native-comp-async-report-warnings-errors 'silent)
(custom-set-variables '(warning-suppress-types '((comp))))
(setq warning-minimum-level :error)


;;; indent by space
(setq-default tab-width 4 indent-tabs-mode nil)


(provide '00_etc)
;;; 00_etc.el ends here
