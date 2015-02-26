(defun user-file (name)
  (expand-file-name name user-emacs-directory))

(add-to-list 'load-path (user-file "lisp"))

(setq custom-file (user-file "custom.el"))

(require 'packages)
(require 'conf/packages)
(if (not (file-exists-p package-user-dir))
    (packages-update))

(require 'tools)

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

(require 'server)
(unless (server-running-p)
  (server-start))

(load-custom-file-if-exists)
