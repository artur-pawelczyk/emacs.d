(require 'ert)

(load (expand-file-name "lisp/boot.el" user-emacs-directory))
(add-to-list 'load-path (user-file "lisp"))
(load-file (user-file "lisp/autoloads.el"))
(add-to-list 'load-path (user-file "site-lisp"))
(load-file (user-file "site-lisp/autoloads.el"))
