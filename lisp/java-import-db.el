;;; java-import-db -- Add Java import statements

;;; Commentary:
;; Use `ji-build-database' to extract information from current buffer.
;; Call `ji-add' to use the information and try to add an import
;; statement for symbol at point.

(eval-when-compile
  '(require 'cl-lib))
(require 'subr-x)
(require 'dash)
(require 's)
(require 'projectile)

;;; Code:

(defvar ji-db nil)

(defvar ji-db-file (expand-file-name "ji-db" user-emacs-directory)
  "Path to a file to store the database for use in another session.")

(defvar ji-save-timer nil)

(defconst ji-package-stmt-pattern "^package [a-zA-z0-9.]+;$")

(defconst ji-import-stmt-pattern "^import\\([[:space:]]+static\\)?[[:space:]]+[a-zA-z0-9.]+;$")

(defconst ji-import-stmt-prefix-pattern "import\\([[:space:]]+static\\)?[[:space:]]+")

(defun ji-timer-running (timer)
  (memql timer timer-list))

(defun ji-full-symbol->symbol-cell (full-symbol)
  (let* ((parts (s-split "\\." full-symbol))
       (symbol (car (last parts)))
       (package (s-join "." (butlast parts))))
    (cons package symbol)))

(defun ji-full-symbol->package (full-symbol)
  (let* ((parts (s-split "\\." full-symbol))
         (symbol (car (last parts)))
         (package (s-join "." (butlast parts))))
    (list (intern package)
          (intern symbol))))

(defun ji-full-symbol-at-point ()
  (save-excursion
    (end-of-line)
    (backward-char)
    (let ((name-end (point)))
      (beginning-of-line)
      (search-forward-regexp ji-import-stmt-prefix-pattern nil :noerror)
      (buffer-substring-no-properties (point) name-end))))

(defun ji-find-imports-impl ()
  (when (search-forward-regexp ji-import-stmt-pattern nil :noerror)
    (cons (ji-full-symbol-at-point) (ji-find-imports-impl))))

(defun ji-find-imports ()
  (save-excursion
    (goto-char (point-min))
    (ji-find-imports-impl)))

(defun ji-packages-list-add-package (list package)
  (cons
   (let* ((package-name (car package))
          (symbols (cdr package))
          ;; FIXME: hot spot
          (old-package (assoc package-name list)))
     (if old-package
         (cl-remove-duplicates (append old-package symbols))
       (cons package-name symbols)))
   list))

(defun ji-find-packages-from-imports ()
  (cl-reduce (lambda (list full-symbol)
            (ji-packages-list-add-package list (ji-full-symbol->package full-symbol)))
          (cons '() (ji-find-imports))))

(defun ji-package-name ()
  (save-excursion
    (goto-char (point-min))
    (if (search-forward-regexp ji-package-stmt-pattern nil :noerror)
        (progn
          (backward-char)
          (let ((name-end (point)))
            (beginning-of-line)
            (search-forward "package ")
            (intern (buffer-substring-no-properties (point) name-end))))
      nil)))

(defun ji-class-name ()
  (save-excursion
    (goto-char (point-min))
    (let ((name-start (or (save-excursion (search-forward-regexp "^\\(public \\)?class " nil :noerror))
                          (save-excursion (search-forward-regexp "^\\(public \\)?interface " nil :noerror)))))
      (if name-start
          (progn
            (goto-char name-start)
            (symbol-at-point))
        ""))))

(defun ji-packages-from-current-class ()
  (let ((package (ji-package-name))
        (class (ji-class-name)))
    (unless (or (string-empty-p package) (string-empty-p class))
      (list (list (ji-package-name) (ji-class-name))))))

(defun ji-find-current-packages (&optional buffer)
  (with-current-buffer (or buffer (current-buffer))
    (append (ji-packages-from-current-class) (ji-find-packages-from-imports))))

(defun ji-build-database ()
  "Add new entries to the `ji-db' database by extracting
information from the current Java buffer.  The buffer is *not*
required to be in java-mode"
  (interactive)
  (dolist (package (ji-find-current-packages))
    (let* ((db (or ji-db (ji-load-database)))
           (old-symbols (gethash (car package) db)))
      (puthash (car package) (cl-remove-duplicates (append (cdr package) old-symbols)) db)))
  (unless (ji-timer-running ji-save-timer)
    (setq ji-save-timer (run-at-time "5 sec" nil #'ji-save-database))))

(defun ji-clear-database ()
  (interactive)
  (setq ji-db (make-hash-table)))

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
  (if (file-exists-p ji-db-file)
      (load-file ji-db-file)
    (setq ji-db (make-hash-table)))
  ji-db)

(defun ji-save-database ()
  "Save the database to a file at `ji-db-file' path.  Discards
  previous contens of the file."
  (interactive)
  (with-temp-file ji-db-file
    (erase-buffer)
    (prin1 `(setq ji-db (quote ,ji-db)) (current-buffer)))
  (message "Java import database saved."))

(defun ji-symbol-imported? (symbol)
  (if (-find (lambda (package)
               (member symbol (cdr package)))
             (ji-find-current-packages))
      t nil))

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

(defun ji-next-line-in-place (point)
  (save-excursion
    (goto-char point)
    (next-line)
    (point)))

(defun ji-import-region-start ()
  (save-excursion
    (goto-char (point-min))
    (-when-let (pos (or (ji-search-forward-in-place ji-import-stmt-pattern)
                        (ji-next-line-in-place (ji-search-forward-in-place ji-package-stmt-pattern))))
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

(defun ji-hash-table-filter (db predicate)
  "Filter hash table DB with PREDICATE accepting a value.
  Returns (KEY . VALUE)."
  (let ((found-keys (-filter (lambda (key)
                            (funcall predicate (gethash key db)))
                          (hash-table-keys db))))
    (mapcar (lambda (key)
              (cons key (gethash key db)))
            found-keys)))

(defun ji-db-find-packages-with-symbol (db symbol)
  (ji-hash-table-filter db (lambda (symbols)
                             (member symbol symbols))))

(defun ji-symbol-at-point ()
  (let ((symbol (symbol-at-point)))
    (if (string-prefix-p "@" (symbol-name symbol))
        (intern (substring (symbol-name symbol) 1))
      symbol)))

(defun ji-add (symbol)
  (interactive (list (ji-symbol-at-point)))
  (if (ji-symbol-imported? symbol)
      (message "Already imported.")
    (let ((db (or ji-db (ji-load-database))))
      (ji-insert-import-stmt
       (completing-read "Package: " (mapcar (lambda (package)
                                              (concat (symbol-name (car package)) "." (symbol-name symbol)))
                                            (ji-db-find-packages-with-symbol db symbol)))))))

(provide 'java-import-db)
;;; java-import-db.el ends here
