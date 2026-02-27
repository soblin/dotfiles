;;; 04_vertico.el --- setting for vertico -*- lexical-binding: t; -*-

;;; Commentary:
;;; - https://qiita.com/nobuyuki86/items/122e85b470b361ded0b4

;;; Code:


;;; vertico
;;; this 5 lines provide helm-like UI !
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-count 10)
  (vertico-resize t)
  )


;;; inside C-x/C-d, C-u goes "up" directory
(use-package extensions/vertico-directory
  :straight (:type built-in)
  :after vertico
  :ensure nil
  :bind (:map vertico-map
              ("C-u" . vertico-directory-up)
              ))

;;; add fuzzy-search in vertico
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))


;;; show file status info
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(provide '04_vertico)
;;; 04_vertico.el ends here
