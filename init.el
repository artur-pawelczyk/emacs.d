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
(load custom-file)

(require 'packages)
(require 'tools)

(require 'conf/packages)
(require 'conf/main)
(require 'conf/auto-complete)
(require 'conf/python)

(require 'init-finish)
