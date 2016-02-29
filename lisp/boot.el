(require 'cl-lib)

(defvar conf/installed-packages '() "Packages installed outside `package.el'")

(defun user-file (name)
  (expand-file-name name user-emacs-directory))

(defun load-custom-file-if-exists ()
  (if (file-exists-p custom-file)
      (load custom-file)))

(defmacro with-package-lazy (packages &rest body)
  "Eval BODY after PACKAGES are loaded.  Don't load the packages.
See `with-package'"
  (declare (indent 1))
  (cl-assert (and (listp packages) (not (eq (car packages) 'quote))))
  (let ((after-load (if (cdr packages)
                        (list `(with-package-lazy ,(cdr packages) ,@body))
                       body)))
    `(eval-after-load ',(car packages)
       (lambda () (progn
                    ,@after-load)))))

(defmacro with-package (packages &rest body)
  "Load PACKAGES and then eval BODY.
See `with-package-lazy'"
  (declare (indent 1))
  (let ((require-stmt (mapcar (lambda (p)
                                `(require ',p nil :noerror)) packages)))
    `(progn
       (with-package-lazy ,packages ,@body)
       ,@require-stmt)))

(defmacro after-init (&rest body)
  "Evaluate body on `after-init-hook'."
  `(add-hook 'after-init-hook (lambda () (progn ,@body))))

(defun conf/installed-p (package)
  (or (memq package conf/installed-packages)
      (package-installed-p package)))

(defun conf/load-directory (directory)
  "Load config files from DIRECTORY."
  (mapc #'load-file (when (file-exists-p directory)
                      (directory-files directory :full "\\..*el\\'"))))

(provide 'boot)
