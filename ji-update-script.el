(package-initialize)
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'java-import-db)

(when (file-exists-p ji-db-file)
  (ji-load-database))
(ji-projectile-build-database)
(ji-save-database)
