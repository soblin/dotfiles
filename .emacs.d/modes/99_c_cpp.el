;;; 99_c_cpp.el --- <Summary> -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package clang-format+
  :init
  (add-hook 'c-mode-common-hook #'clang-format+-mode)
  )

(provide '99_c_cpp)
;;; 99_c_cpp.el ends here
