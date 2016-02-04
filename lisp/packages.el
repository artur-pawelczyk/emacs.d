(require 'package)
(package-initialize)

(defun conf/install-package (package)
  "Install PACKAGE if not installed."
  (when (and package (not (conf/installed-p package)))
    (package-install package)))

(defun conf/install-selected-packages ()
  (interactive)
  (package-refresh-contents)
  (if (fboundp 'package-install-selected-packages)
      (package-install-selected-packages)
    (mapcar 'conf/install-package user-package-list)))

(provide 'packages)
