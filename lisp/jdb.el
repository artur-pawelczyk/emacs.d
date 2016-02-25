(require 'semantic)
(require 'subr-x)

(defun jdb-ensure-mode ()
  (cl-assert (eq major-mode 'java-mode))
  (semantic-mode 1))

(defun jdb-tag-package (tags)
  (semantic-tag-full-package (car tags)))

(defun jdb-tag-class (tags)
  (let ((hierarchy (mapcar #'semantic-tag-name (butlast tags))))
    (string-join hierarchy "$")))

(defun jdb-tag-method (tags)
  (semantic-tag-name (car (last tags))))

(defun jdb-current-method ()
  (let ((tags (semantic-find-tag-by-overlay)))
    (unless tags (error "No semantic information in the buffer."))
    (concat (jdb-tag-package tags)
             "."
             (jdb-tag-class tags)
             "."
             (jdb-tag-method tags))))

(defun jdb-current-class ()
  (let ((tags (semantic-find-tag-by-overlay)))
    (unless tags (error "No semantic information in the buffer."))
    (concat (jdb-tag-package tags)
            "."
            (jdb-tag-class tags))))

(defun jdb-stop-in-method ()
  (interactive)
  (jdb-ensure-mode)
  (gud-call (format "stop in %s" (jdb-current-method))))

(defun jdb-stop-at-point ()
  (interactive)
  (jdb-ensure-mode)
  (gud-call (format "stop at %s:%s" (jdb-current-class) (line-number-at-pos))))

(provide 'jdb)
