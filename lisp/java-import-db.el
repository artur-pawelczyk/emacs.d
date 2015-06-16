;;; java-import-db -- Add Java import statements

;;; Commentary:
;; Use `ji-build-database' to extract information from current buffer.
;; Call `ji-add' to use the information and try to add an import
;; statement for symbol at point.

(require 'dash)
(require 's)
(require 'projectile)

;;; Code:

(defvar ji-db '()
  "Association list: symbol name => list of packages containing the symbol")

(defvar ji-db-file (expand-file-name "ji-db" user-emacs-directory)
  "Path to a file to store the database for use in another session.")

(defvar ji-save-timer nil)

(defconst ji-package-stmt-pattern "^package [a-zA-z.]+;$")

(defconst ji-import-stmt-pattern "^import [a-zA-z.]+;$")

(defun ji-timer-running (timer)
  (memql timer timer-list))

(defun ji-entry->identifier (entry)
  (s-join "." (list (cdr entry) (car entry))))

(defun ji-identifier->entry (identifier)
  (let* ((parts (s-split "\\." identifier))
       (symbol (car (last parts)))
       (package (s-join "." (butlast parts))))
    (cons symbol package)))

(defun ji-identifier-at-point ()
  (save-excursion
    (end-of-line)
    (backward-char)
    (let ((name-end (point)))
      (beginning-of-line)
      (search-forward-regexp "import " nil :noerror)
      (buffer-substring-no-properties (point) name-end))))

(defun ji-find-imports-impl ()
  (when (search-forward-regexp ji-import-stmt-pattern nil :noerror)
    (cons (ji-identifier-at-point) (ji-find-imports-impl))))

(defun ji-find-imports ()
  (save-excursion
    (goto-char (point-min))
    (ji-find-imports-impl)))

(defun ji-find-current-entries (&optional buffer)
  (with-current-buffer (or buffer (current-buffer))
    (mapcar #'ji-identifier->entry (ji-find-imports))))

(defun ji-build-database ()
  "Add new entries to the `ji-db' database by extracting
information from the current Java buffer"
  (interactive)
  (setq ji-db (-concat (ji-find-current-entries) ji-db))
  (unless (ji-timer-running ji-save-timer)
    (setq ji-save-timer (run-at-time "5 sec" nil #'ji-save-database))))

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

(defun ji-search-forward-in-place (pattern)
  "Search PATTERN from current positoin using
  `search-forward-regexp' and return the position of the first
  match or nil if none."
  (save-excursion
    (when (search-forward-regexp pattern nil :noerror)
      (beginning-of-line)
      (point))))

(defun ji-search-backward-in-place (pattern)
  "Search PATTERN from current positoin using
  `search-backward-regexp' and return the position of the first
  match or nil if none."
  (save-excursion
    (when (search-backward-regexp pattern nil :noerror)
      (beginning-of-line)
      (point))))

(defun ji-import-region-start ()
  (save-excursion
    (goto-char (point-min))
    (-when-let (pos (ji-search-forward-in-place ji-import-stmt-pattern))
      (goto-char pos))
    (beginning-of-line)
    (point)))

(defun ji-import-region-end ()
  (save-excursion
    (goto-char (point-max))
    (-when-let (pos (or (ji-search-backward-in-place ji-import-stmt-pattern)
                        (ji-search-backward-in-place ji-package-stmt-pattern)
                        (point-min)))
      (goto-char pos))
    (end-of-line)
    (point)))

(defun ji-sort-import-stmts ()
  (interactive)
  (sort-lines nil (ji-import-region-start) (1+ (ji-import-region-end))))

(defun ji-insert-import-stmt (name)
  (save-excursion
    (goto-char (ji-import-region-start))
    (insert "import " name ";\n")
    (ji-sort-import-stmts)))

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
      (with-temp-buffer (insert-file-contents path)
                        (ji-build-database)))))

(defun ji-load-database ()
  (interactive)
  (load-file ji-db-file))

(defun ji-save-database ()
  "Save the database to a file at `ji-db-file' path.  Discards
  previous contens of the file."
  (interactive)
  (with-temp-file ji-db-file
    (erase-buffer)
    (prin1 `(setq ji-db (quote ,ji-db)) (current-buffer)))
  (message "Java import database saved."))

(provide 'java-import-db)
;;; java-import-db.el ends here
