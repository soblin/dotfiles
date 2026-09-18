;;; 99_docker.el --- <Summary> -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package dockerfile-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.[Dd]ockerfile\\'" . dockerfile-mode))
  )

(use-package docker-compose-mode
  :init
  )

(provide '99_docker)
;;; 99_docker.el ends here
