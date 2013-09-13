(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(defun user-file (name)
  (expand-file-name name user-emacs-directory))

(add-to-list 'load-path user-emacs-directory)
(add-to-list 'load-path (user-file "setup"))
(add-to-list 'load-path (user-file "lisp"))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(require 'packages)

(require 'conf/packages)
