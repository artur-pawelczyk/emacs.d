(load (expand-file-name "lisp/boot.el" user-emacs-directory))

(add-to-list 'load-path (user-file "lisp"))
(load-file (user-file "lisp/autoloads.el"))
(add-to-list 'load-path (user-file "site-lisp"))
(load-file (user-file "site-lisp/autoloads.el"))

(setq custom-file (user-file "custom.el"))

(when (file-exists-p (user-file "before-init.el"))
  (load-file (user-file "before-init.el")))

(require 'packages)
(require 'conf/packages)
(if (not (file-exists-p package-user-dir))
    (packages-update))

(require 'boot)
(require 'tools)

(load-custom-file-if-exists)
(require 'conf/main)
(require 'conf/basic-editing)
(require 'conf/dired)
(require 'conf/buffer-list)
(require 'conf/completion)
(require 'conf/python)
(require 'conf/cc)
(require 'conf/java)
(require 'conf/web)
(require 'conf/javascript)
(require 'conf/ediff)
(require 'conf/lisp)
(require 'conf/org)
(require 'conf/yasnippet)
(require 'conf/mode-line)
(require 'conf/clojure)
(require 'conf/projects)
(require 'conf/sql)
(require 'conf/emms)
(require 'conf/scilab)
(require 'conf/vc)

(when (eq system-type 'cygwin)
  (require 'conf/cygwin))

(require 'server)
(unless (server-running-p)
  (server-start))

(when (file-exists-p (user-file "after-init.el"))
  (load-file (user-file "after-init.el")))
