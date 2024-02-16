;;; 21_python.el --- settings for python

;;; Commentary:
;;

;;; Code:

(require 'python)
(setq auto-mode-alist (cons '("\\.py\\'" . python-mode) auto-mode-alist))
(add-hook 'python-mode-hook
          (lambda ()
            (define-key python-mode-map (kbd "\C-m") 'newline-and-indent)
            (define-key python-mode-map (kbd "RET") 'newline-and-indent)))
;; (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

(add-hook 'python-mode-hook 'eglot-ensure)

(add-hook 'python-mode-hook 'blacken-mode)

;; https://tam5917.hatenablog.com/entry/20
;; https://github.com/pythonic-emacs/blacken?tab=readme-ov-file#usage pyproject.tomlがあるときだけblackenするようにする
(use-package blacken
  :delight
  :hook (python-mode . blacken-mode)
  :config
  (setq blacken-only-if-project-is-blackened t))

(use-package lsp-pyright
  :if (executable-find "pyright")
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))

(add-hook 'python-mode-hook
          (lambda ()
             (add-hook 'before-save-hook 'py-isort-before-save)))

(use-package pyvenv
  :diminish
  :config
  (setq pyvenv-mode-line-indicator
        '(pyvenv-virtual-env-name ("[venv:" pyvenv-virtual-env-name "] ")))
  (pyvenv-mode +1))

;; https://tam5917.hatenablog.com/entry/2021/03/28/204747
(eval-when-compile
  (require 'ein)
  (require 'ein-notebook)
  (require 'ein-notebooklist)
  (require 'ein-markdown-mode)
  (require 'smartrep))
(setq ein:output-area-inlined-images t)
(require 'ein-markdown-mode)
(setq ein:markdown-command "pandoc --metadata pagetitle=\"markdown preview\" -f markdown -c ~/.pandoc/github-markdown.css -s --self-contained --mathjax=https://raw.githubusercontent.com/ustasb/dotfiles/b54b8f502eb94d6146c2a02bfc62ebda72b91035/pandoc/mathjax.js")
(defun ein:markdown-preview ()
  (interactive)
  (ein:markdown-standalone)
  (browse-url-of-buffer ein:markdown-output-buffer-name))

;; emacsからeinを起動すると外部パッケージを認識してくれない
;; generate-configでpassword/tokenを利用しない設定にした上で，ein:loginでhttp://localhost:8888に接続すると上手くいく
(provide '21_python)

;;; End:

;;; 21_python ends here
