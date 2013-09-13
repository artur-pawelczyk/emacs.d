(require 'package)
(package-initialize)

(defun packages-install (packages)
  "Check if packages in PACKAGES are installed, if not install them"
  (let ((package (car packages)))
    (when packages
      (when (and package (not (package-installed-p package)))
        (package-install package))
      (packages-install (cdr packages)))))

(defun packages-update ()
  "Update package list and install packages spefified by `user-package-list'"
  (interactive)
  (condition-case nil
      (packages-install user-package-list)
    (error
     (package-refresh-contents)
     (packages-install user-package-list))))

(provide 'packages)
