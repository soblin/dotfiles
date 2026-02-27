;;; 00_gc.el --- garbage collector and performance setting -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

;;; performance
;;; - https://zenn.dev/hironori_ueno/articles/bff12deec6cec9
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 128 1024 1024)
                  gc-cons-percentage 0.2)))
(add-hook 'focus-out-hook #'garbage-collect)
(setq garbage-collection-messages t)

;;; performance tuning
(setq read-process-output-max (* 4 1024 1024))
(setq process-adaptive-read-buffering nil)


;;; gcmh-mode
;;; - https://www.grugrut.net/posts/202101032247/
;;; - https://github.com/purcell/emacs.d/blob/c0a2ac6755f6e9a7fd00a3f18e9e63ca75c62485/init.el#L42-L49
;;; gcmh create garbage ?
;;; - https://qiita.com/nobuyuki86/items/122e85b470b361ded0b4#%E3%82%AC%E3%83%99%E3%83%BC%E3%82%B8%E3%82%B3%E3%83%AC%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3

;;(use-package gcmh
;;  :ensure t
;;  :custom
;;  (gcmh-high-cons-threshold (* 128 1024 1024))
;;  :config
;;  (gcmh-mode 1)
;;  )
(setq jit-lock-defer-time 0)

(setq vc-handled-backends '(Git))

(provide '00_gc)
;;; 00_gc.el ends here
