(load (expand-file-name "lisp/boot.el" user-emacs-directory))

(add-to-list 'load-path (user-file "lisp"))
(load-file (user-file "lisp/autoloads.el"))
(add-to-list 'load-path (user-file "site-lisp"))
(load-file (user-file "site-lisp/autoloads.el"))

(setq custom-file (user-file "custom.el"))

(when (file-exists-p (user-file "before-init.el"))
  (load-file (user-file "before-init.el")))

(package-initialize)
(require 'packages)
(load-library "conf/packages")
(if (not (file-exists-p package-user-dir))
    (conf/install-selected-packages))

(require 'boot)
(require 'tools)

(load-custom-file-if-exists)
(conf/load-directory (user-file "lisp/conf"))

(when (eq system-type 'cygwin)
  (conf/load-directory (user-file "lisp/conf/cygwin")))

(require 'server)
(unless (server-running-p)
  (server-start))

(when (file-exists-p (user-file "after-init.el"))
  (load-file (user-file "after-init.el")))

(conf/load-directory (user-file "after-init.d"))
