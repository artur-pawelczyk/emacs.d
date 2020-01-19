(autoload 'scilab-mode "scilab" nil :interactive)
(autoload 'scilab-shell "scilab" nil :interactive)


(unless (package-installed-p 'magit)
  (message "Magit not installed through ELPA.")
  (add-to-list 'load-path (user-file "site-lisp/magit/lisp"))
  (when (file-exists-p (user-file "site-lisp/magit/lisp/magit-autoloads.el"))
    (load (user-file "site-lisp/magit/lisp/magit-autoloads.el"))
    (add-to-list 'conf/installed-packages 'magit)))

(with-package-lazy (info)
  (add-to-list 'Info-additional-directory-list (user-file "site-lisp/magit/Documentation/")))
