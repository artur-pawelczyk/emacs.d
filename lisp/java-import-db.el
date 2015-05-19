;;; java-import-db -- Add Java import statements

;;; Commentary:
;; Use `ji-build-database' to extract information from current buffer.
;; Call `ji-add' to use the information and try to add an import
;; statement for symbol at point.

(require 'dash)
(require 's)
(require 'java-import)
(require 'semantic)
(require 'semantic/tag)
(require 'projectile)

;;; Code:

(defvar ji-db '()
  "Association list: symbol name => list of packages containing the symbol")

(defun ji-import-tag? (semantic-tag)
  "Is SEMANTIC-TAG a Java import statement?"
  (equal 'include (semantic-tag-class semantic-tag)))

(defun ji-extract-imports (semantic-tags)
  (mapcar #'semantic-tag-name (-filter #'ji-import-tag? semantic-tags)))

(defun ji-identifier->entry (identifier)
  (let* ((parts (s-split "\\." identifier))
       (symbol (car (last parts)))
       (package (s-join "." (butlast parts))))
    (cons symbol package)))

(defun ji-entry->identifier (entry)
  (s-join "." (list (cdr entry) (car entry))))

(defun ji-find-current-entries (&optional buffer)
  (with-current-buffer (or buffer (current-buffer))
    (unless semantic-mode
      (semantic-mode 1))
    (->> (semantic-fetch-tags)
         ji-extract-imports
         (mapcar #'ji-identifier->entry))))

(defun ji-build-database ()
  "Add new entries to the `ji-db' database by extracting
information from the current Java buffer"
  (interactive)
  (when (eq major-mode 'java-mode)
    (setq ji-db (-concat (ji-find-current-entries) ji-db))))

(defun ji-clear-database ()
  (interactive)
  (setq ji-db '()))

(defun ji-db-find-first (name)
  (ji-entry->identifier (assoc name ji-db)))

(defun ji-db-find-all (name)
  (mapcar #'ji-entry->identifier
          (-filter (lambda (e) (equal name (car e))) ji-db)))

(defun ji-wildcard-imports ()
  (ji-db-find-all "*"))

(defun ji-insert-import-stmt (name)
  (save-excursion
    (jdl/goto-first-import)
    (insert "import " name ";\n")
    (sort-java-imports)))

(defun ji-currently-imported? (name)
  (assoc name (ji-find-current-entries)))

(defun ji-add ()
  "Try to find symbol at point in the database."
  (interactive)
  (let ((name (symbol-name (symbol-at-point))))
    (if (ji-currently-imported? name)
        (message "Already imported")
      (ji-insert-import-stmt
       (completing-read "Package: " (-concat (ji-db-find-all name) (ji-wildcard-imports)))))))

(defun ji-projectile-java-files ()
  (-filter (-partial #'s-matches? ".java$") (projectile-current-project-files)))

(defun ji-projectile-build-database ()
  (interactive)
  (dolist (file (ji-projectile-java-files))
    (let ((path (expand-file-name file (projectile-project-root))))
      (with-current-buffer (find-file-noselect path)
        (ji-build-database)))))

(provide 'java-import-db)
;;; java-import-db.el ends here
