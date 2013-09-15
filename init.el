(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(eval-after-load 'init-finish '(menu-bar-mode 1))
(eval-after-load 'init-finish '(scroll-bar-mode 1))

(defun user-file (name)
  (expand-file-name name user-emacs-directory))

(add-to-list 'load-path user-emacs-directory)
(add-to-list 'load-path (user-file "setup"))
(add-to-list 'load-path (user-file "lisp"))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(eval-after-load 'init-finish '(load-custom-file-if-exists))

(require 'packages)
(require 'conf/packages)
(if (not (file-exists-p package-user-dir))
    (packages-update))

(require 'tools)

(require 'conf/main)
(require 'conf/dired)
(require 'conf/auto-complete)
(require 'conf/python)
(require 'conf/java)
(require 'conf/javascript)
(require 'conf/ediff)

(require 'init-finish)
