(defun user-file (name)
  (expand-file-name name user-emacs-directory))

(add-to-list 'load-path (user-file "lisp"))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(eval-after-load 'init-finish '(server-start))
(eval-after-load 'init-finish '(load-custom-file-if-exists))

(require 'packages)
(require 'conf/packages)
(if (not (file-exists-p package-user-dir))
    (packages-update))

(require 'tools)

(require 'conf/main)
(require 'conf/dired)
(require 'conf/buffer-list)
(require 'conf/auto-complete)
(require 'conf/python)
(require 'conf/java)
(require 'conf/jsp)
(require 'conf/javascript)
(require 'conf/ediff)
(require 'conf/lisp)
(require 'conf/org)

(require 'init-finish)
(put 'narrow-to-region 'disabled nil)
