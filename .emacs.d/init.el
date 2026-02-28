;;; init.el --- <Summary> -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;;; straight.el
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)


;;; setting for path
;;; - https://github.com/bbatsov/prelude/blob/62f7af5e5ba56583bf4950845a71df996b3269d2/init.el#L92-L95
;;; - https://github.com/purcell/emacs.d/blob/c0a2ac6755f6e9a7fd00a3f18e9e63ca75c62485/init.el#L18
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))

(require '00_gc)
(require '00_etc)
(require '01_global_keybindings)
(require '01_which_key)
(require '02_look_feel)
(require '02_theme)
(require '03_tab_setting)
(require '04_vertico)
(require '05_magit)


(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))
(require '99_yaml)
(require '99_docker)

(provide 'init)
;;; init.el ends here
