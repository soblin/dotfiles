 ;;; 03_tab_setting.el --- setting for tabs -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode)
  (centaur-tabs-headline-match)
  :custom
  (centaur-tabs-style "box")
  (centaur-tabs-set-icons t)
  (centaur-tabs-icons-type 'nerd-icons)
  (centaur-tabs-set-bar 'left)
  (centaur-tabs-set-modified-marker t)
  (centaur-tabs-cycle-scope 'tabs)
  (centaur-tabs-auto-scroll-flag t)
  (centaur-tabs-set-bar 'under)
  (x-underline-at-descent-line t)
  :bind
  ("C-x C-n" . centaur-tabs-backward)
  ("C-x C-p" . centaur-tabs-forward)
  )

(defun my/centaur-normal-buffer-p (buffer)
  (with-current-buffer buffer
    (let ((name (buffer-name)))
      (or
       (string= name "*scratch*")
       buffer-file-name
       )
      )
    )
  )
(defun my/centaur-tabs-buffer-groups ()
  (if (my/centaur-normal-buffer-p (current-buffer))
      '("Main")
    '("Hidden")
    )
  )
(setq centaur-tabs-buffer-groups-function #'my/centaur-tabs-buffer-groups)


;;; tab-bar movement
;;; - https://tam5917.hatenablog.com/entry/2024/01/10/151334
(defvar tab-bar-top-tab "1")
(defvar tab-bar-bottom-tab "9")
(defun tab-bar-set-keybind ()
  (mapc (lambda (i)
          (global-set-key (kbd (format "C-M-%d" i))
                          `(lambda ()
                             (interactive)
                             (tab-bar-select-tab ,(int-to-string i)))))
        (number-sequence (string-to-number tab-bar-top-tab)
                         (string-to-number tab-bar-bottom-tab))))
(tab-bar-set-keybind)

(use-package tab-bar
  :ensure nil ;; built-in
  :config
  (tab-bar-mode 1)

  :custom
  (tab-bar-separator "")
  (tab-bar-new-tab-choice "*scratch*")
  (tab-bar-show t)
  (tab-bar-tab-hints t) ;; show number
  (tab-bar-tab-name-format-function #'my/tab-bar-tab-name-format)

  :init
  ;;; - https://www.reddit.com/r/emacs/comments/t4j5lu/tabbarmode_how_to_change_tab_bar_appearence/
  (set-face-attribute 'tab-bar nil
                      :height 1.1
                      :weight 'regular
                      )
  (set-face-attribute 'tab-bar-tab nil
                      :height 1.1
                      :underline "#bd93f9"
                      :weight 'bold
                      :slant 'italic
                      )
  (defface my-tab-bar-tab-active
    `((t :inherit tab-bar-tab
         :foreground ,(face-attribute 'centaur-tabs-selected :foreground nil t)
         :background "#33475e"
         ))
    "active tab face"
    :group 'my-tab-bar-face)
  (defface my-tab-bar-tab-inactive
    `((t :inherit tab-bar
         :foreground ,(face-attribute 'centaur-tabs-unselected :foreground nil t)
         :background ,(face-attribute 'centaur-tabs-unselected :background nil t)
         ))
    "inactive tab face"
    :group 'my-tab-bar-face)

  (defun my/tab-bar-tab-name-format (tab i)
    ;; i starts from 1, tab-bar--current-tab-index from 0
    (if (eq (- i 1) (tab-bar--current-tab-index))
        (propertize (concat "📁 " (alist-get 'name tab) " " tab-bar-close-button " ")
                    'face 'my-tab-bar-tab-active
                    )
      (propertize (concat "📁 " (alist-get 'name tab) " " tab-bar-close-button " ")
                  'face 'my-tab-bar-tab-inactive
                  )
      )
    )

  ;; open a new tab if a file/dir belongs to a new project
  (defun my/ensure-default-tab ()
    (if (= (length (tab-bar-tabs)) 1)
        (tab-bar-rename-tab "home")
      (unless (member "home"
                      (mapcar (lambda (tab)
                                (alist-get 'name tab))
                              (tab-bar-tabs)))
        (tab-bar-new-tab)
        (tab-bar-rename-tab "home")))
    )

  (defun my/project-name ()
    (when-let* ((proj (project-current nil))
                (root (project-root proj)))
      (file-name-nondirectory
       (directory-file-name root))))

  (defun my/project-tab-name ()
    "Return project name for current buffer."
    (when-let* ((proj (project-current nil))
                (root (project-root proj)))
      (file-name-nondirectory
       (directory-file-name root))))

  (defun my/switch-tab-by-project ()
    (let* ((proj-name (my/project-name))
           (target (or proj-name "home"))
           (tabs (tab-bar-tabs))
           (buf (current-buffer))
           (existing
            (seq-find
             (lambda (tab)
               (string= (alist-get 'name tab) target))
             tabs)))
      (my/ensure-default-tab)
      (if existing
          (tab-bar-select-tab
           (1+ (seq-position tabs existing)))
        (tab-bar-switch-to-tab target)
        (switch-to-buffer buf))))

  (add-hook 'find-file-hook #'my/switch-tab-by-project)
  (add-hook 'dired-mode-hook #'my/switch-tab-by-project)
  (add-hook 'emacs-startup-hook
            (lambda ()
              (my/ensure-default-tab)
              ))
  )

(provide '03_tab_setting)
;;; 03_tab_setting.el ends here
