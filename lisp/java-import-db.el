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
    (->> (semantic-fetch-tags)
      ji-extract-imports
      (mapcar #'ji-identifier->entry))))

(defun ji-build-database ()
  "Add new entries to the `ji-db' database by extracting
information from the current Java buffer"
  (interactive)
  (setq ji-db (-concat (ji-find-current-entries) ji-db)))

(defun ji-clear-database ()
  (interactive)
  (setq ji-db '()))

(defun ji-db-find-first (name)
  (ji-entry->identifier (assoc name ji-db)))

(defun ji-insert-import-stmt (name)
  (save-excursion
    (jdl/goto-first-import)
    (insert "import " name ";\n")
    (sort-java-imports)))

(defun ji-currently-imported? (name)
  (assoc name (ji-find-current-entries)))

(defun ji-add ()
  "Try to add an import statement for a symbol at point.  Sort
import statements if a new entry was added."
  (interactive)
  (let ((name (symbol-name (symbol-at-point))))
    (when (not (ji-currently-imported? name))
      (ji-insert-import-stmt (ji-db-find-first name)))))

(provide 'java-import-db)
;;; java-import-db.el ends here
