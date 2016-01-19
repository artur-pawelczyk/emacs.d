(require 'package)
(package-initialize)

(defun packages-install (package)
  "Install PACKAGE if not installed."
  (when (and package (not (conf/installed-p package)))
    (package-install package)))

(defun packages-update ()
  "Update package list and install packages spefified by `user-package-list'"
  (interactive)
  (condition-case nil
      (mapcar 'packages-install user-package-list)
    (error
     (package-refresh-contents)
     (mapcar 'packages-install user-package-list))))



(provide 'packages)
