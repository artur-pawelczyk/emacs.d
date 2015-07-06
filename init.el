(defun user-file (name)
  (expand-file-name name user-emacs-directory))

(add-to-list 'load-path (user-file "lisp"))
(add-to-list 'load-path (user-file "site-lisp"))

(setq custom-file (user-file "custom.el"))

(when (file-exists-p (user-file "before-init.el"))
  (load-file (user-file "before-init.el")))

(require 'packages)
(require 'conf/packages)
(if (not (file-exists-p package-user-dir))
    (packages-update))

(require 'tools)
(require 'git-timemachine-fix)
(autoload 'ji-add "java-import-db" nil :interactive)
(autoload 'ji-build-database "java-import-db" nil :interactive)
(autoload 'ji-projectile-build-database "java-import-db" nil :interactive)
(autoload 'ext-edit-region "ext-edit" nil :interactive)


(autoload 'scilab-mode "scilab" nil :interactive)
(autoload 'scilab-shell "scilab" nil :interactive)

(require 'conf/main)
(require 'conf/dired)
(require 'conf/buffer-list)
(require 'conf/completion)
(require 'conf/python)
(require 'conf/java)
(require 'conf/jsp)
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

(load-custom-file-if-exists)

(when (file-exists-p (user-file "after-init.el"))
  (load-file (user-file "after-init.el")))
