;;; 22_yatex.el --- settings for LaTeX

;;; Commentary:
;;

;;; Code:

;; 拡張子が .tex なら yatex-mode に
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq auto-mode-alist
      (append '(("\\.tex$" . yatex-mode)
		("\\.ltx$" . yatex-mode)
		("\\.cls$" . yatex-mode)
		("\\.sty$" . yatex-mode)
		("\\.clo$" . yatex-mode)
		("\\.bbl$" . yatex-mode)) auto-mode-alist))

;;\C-c t jでコンパイル，\C-c t pでプレビュー
(setq YaTeX-prefix "\C-c")
;; texファイルを開くと自動でRefTexモード
;;
(add-hook 'yatex-mode-hook 'turn-on-reftex)

(add-hook 'yatex-mode-hook
	  '(lambda ()
	     (setq YaTeX-use-AMS-LaTeX t) ; align で数式モードになる
	     (setq YaTeX-use-hilit19 nil
		   YateX-use-font-lock t)
	     (electric-indent-local-mode -1)
	     (setq indent-tabs-mode nil);;tabの幅を変える
	     (setq indent-level 4)
	     (setq tab-width 4)
	     (setq auto-fill-function nil)
	     (setq tex-command "platex2pdf") ;; 自作したコマンドを
	     (setq dvi2-command "evince") ; preview command
	     (setq bibtex-command "pbibtex")
	     (setq dviprint-command-format "dvipdfmx %s")
	     (setq YaTeX-kanji-code 4) ; UTF-8 の設定
	     (setq tex-pdfview-command "evince"))) ; preview command

;;YaTeXとlatex-math-preview 最終更新2017/4
(add-hook 'yatex-mode-hook
	  '(lambda ()
	     (YaTeX-define-key "p" 'latex-math-preview-expression)
	     (YaTeX-define-key "\C-p" 'latex-math-preview-save-image-file)
	     (YaTeX-define-key "j" 'latex-math-preview-insert-symbol)
	     (YaTeX-define-key "\C-j" 'latex-math-preview-last-symbol-again)
	     (YaTeX-define-key "\C-b" 'latex-math-preview-beamer-frame)))
(setq latex-math-preview-in-math-mode-p-func 'YaTeX-in-math-mode-p)
(setq latex-math-preview-latex-command "/usr/bin/platex")
(setq latex-math-preview-command-dvipng "/usr/bin/dvipng")
(setq latex-math-preview-command-dvips "/usr/bin/dvips")

(provide '22_yatex)
;;; End:

;;; 22_yatex ends here
