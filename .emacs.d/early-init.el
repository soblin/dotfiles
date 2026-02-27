;;; early-init.el --- Emacs27+ pre-instantiation config -*- lexical-binding: t; -*-

;;; Commentary:
;;; References:
;;;
;;; ## overall
;;; 1. https://zenn.dev/hironori_ueno/articles/bff12deec6cec9
;;;
;;; ## straight.el:
;;; 1. https://github.com/radian-software/straight.el/blob/644ba036611d5952ec49f1a8abfb6851c19ac86a/README.md?plain=1#L194-L220
;;;

;;; Code:

;;; performance
(setq frame-inhibit-implied-resize t
      inhibit-compacting-font-caches t
      default-frame-alist
      '(
        (width . 80) (height . 30)
        (vertical-scroll-bars . nil)
        (horizontal-scroll-bars . nil)
        (tool-bar-lines . 0)
        (menu-bar-lines . 0)
        (undecorated . nil)
        (fullscreen . nil)
        (inhibit-double-buffering . t)))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(when (boundp 'native-comp-async-report-warnings-errors)
  (setq native-comp-async-report-warnings-errors nil))


;;; straight.el
;;; disable auto package loading for straight.el
(setq package-enable-at-startup nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(provide 'early-init)
;;; early-init.el ends here
