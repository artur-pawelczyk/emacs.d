(require 'semantic)
(require 'semantic/tag)
(require 'semantic/tag-ls)
(require 'dash)
(require 'subr-x)

(defun java-tag-at-point (&optional force-refresh)
  (when force-refresh
    (semantic-force-refresh))
  (or (semantic-find-tag-by-overlay)
      (when (y-or-n-p "Semantic information for found. Refresh?")
        (java-tag-at-point :force-refresh))))

(defun java-tag-at-point-check ()
  (or (java-tag-at-point)
      (error "No semantic information in the buffer")))

(defun java-tag-package (tags)
  (semantic-tag-full-package (car tags)))

(defun java-tag-class (tags)
  (let* ((classes (-filter (lambda (tag) (equal "class" (semantic-tag-type tag))) tags))
         (names (mapcar #'semantic-tag-name classes)))
    (string-join (seq-uniq names) "$")))

(defun java-tag-method (tags)
  (semantic-tag-name (car (last tags))))

(defun java-full-method-at-point ()
    (let ((tags (java-tag-at-point-check)))
    (concat (java-tag-package tags)
             "."
             (java-tag-class tags)
             "."
             (java-tag-method tags))))

(defun java-full-class-at-point ()
  (let ((tags (java-tag-at-point-check)))
    (concat (java-tag-package tags)
            "."
            (java-tag-class tags))))

(defun java-method-at-point ()
  (let ((tags (java-tag-at-point-check)))
    (java-tag-method tags)))

(provide 'java-parser)
