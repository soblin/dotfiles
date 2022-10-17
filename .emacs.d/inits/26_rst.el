;;; 26_rst.el --- settings for reStructured Text

;;; Commentary:
;;

;;; Code:
;; load rst.el on startup
(require 'rst)
;;
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
		("\\.rest$" . rst-mode)) auto-mode-alist))
;;
(setq frame-background-mode 'dark)
;;
(add-hook 'rst-mode-hook #'(lambda() (setq indent-tabs-mode nil)))
(add-hook 'rst-mode-hook
          #'(lambda ()
             (local-set-key (kbd "\C-x\C-m") #'(lambda (eq)
                                           (interactive "sEnter LaTeX Equation.")
                                           (insert (concat " :math:`" eq "` "))

                                           ))))

(defun ins-math-env (eq)
  "Insert sphinx math env as EQ."
  (interactive "sEnter your math equation: ")
  (progn (insert "\n.. math::\n   :nowrap:\n\n")
         (insert "   \\begin{align*}\n   ")
         (insert eq)
         (insert "\n   \\end{align*}\n\n"))
  )

(defun ins-figure-env (filename)
  "Insert sphinx figure as FILENAME."
  (interactive "sEnter figure filename: ")
  (progn (insert (concat "\n.. figure:: " filename "\n"))
         (insert "   :align: center\n")
         (insert "   :width: 50%\n")
         (insert (concat "   :alt: " filename "\n\n"))))

(defun ins-meta-env (description keywords)
  "Insert description and keywords tags"
  (interactive "sEnter description entry: \nsEnter keyword entry: ")
  (progn (insert ".. meta::\n")
         (insert (concat "   :description: " description "\n"))
         (insert (concat "   :keywords: " keywords "\n")))
  )

(defun sphinx-indent ()
  "Disable redundant indent in Sphinx mode"
  (interactive)
  (newline)
  (indent-relative-maybe)
  )

(define-key rst-mode-map (kbd "C-m") 'sphinx-indent)

(provide '26_rst)
;;; End:
;;; 26_rst ends here
