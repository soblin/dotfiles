;;; 27_md.el --- settings for markdown

;;; Commentary:
;;

;;; Code:


;; ショッキングピンクとか使ってて見た目がやばいので変える
(setq markdown-preview-stylesheets nil)

(add-hook 'markdown-mode-hook
          #'(lambda ()
             (local-set-key (kbd "\C-x\C-m") #'(lambda (eq)
                                                 (interactive "sEnter LaTeX Equation: ")
                                                 (progn (insert "$$\\begin{align}\n")
                                                        (insert eq)
                                                        (insert "\n\\end{align}$$\n"))
                                                 ))))

(add-hook 'markdown-mode-hook
          #'(lambda ()
             (local-set-key (kbd "\C-c\C-m") #'(lambda (eq)
                                                 (interactive "sEnter math snippet: ")
                                                 (progn (insert (concat " $" eq "$ ")))
                                                 ))))

(provide '27_md)

;;; End:
;;; 27_md ends here
