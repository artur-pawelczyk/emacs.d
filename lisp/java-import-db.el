;;; java-import-db -- Add Java import statements

;;; Commentary:
;; Use `ji-build-database' to extract information from current buffer.
;; Call `ji-add' to use the information and try to add an import
;; statement for symbol at point.

(eval-when-compile
  '(require 'cl-lib))
(require 'dash)
(require 's)
(require 'projectile)

;;; Code:

(defvar ji-db '())

(defvar ji-db-file (expand-file-name "ji-db" user-emacs-directory)
  "Path to a file to store the database for use in another session.")

(defvar ji-save-timer nil)

(defconst ji-package-stmt-pattern "^package [a-zA-z.]+;$")

(defconst ji-import-stmt-pattern "^import [a-zA-z.]+;$")

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
    (list package symbol)))

(defun ji-full-symbol-at-point ()
  (save-excursion
    (end-of-line)
    (backward-char)
    (let ((name-end (point)))
      (beginning-of-line)
      (search-forward-regexp "import " nil :noerror)
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
          (old-package (assoc package-name list)))
     (if old-package
         (remove-duplicates (append old-package symbols))
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
            (buffer-substring-no-properties (point) name-end)))
      "")))

(defun ji-class-name ()
  (save-excursion
    (goto-char (point-min))
    (let ((name-start (or (save-excursion (search-forward "class " nil :noerror))
                          (save-excursion (search-forward "interface " nil :noerror)))))
      (if name-start
          (progn
            (goto-char name-start)
            (symbol-name (symbol-at-point)))
        ""))))

(defun ji-package-from-current-class ()
  "Return the symbol cell corresponding to the current class/file."
  (list (ji-package-name) (ji-class-name)))

(defun ji-find-current-packages (&optional buffer)
  (with-current-buffer (or buffer (current-buffer))
    (cons (ji-package-from-current-class) (ji-find-packages-from-imports))))

(defun ji-build-database ()
  "Add new entries to the `ji-db' database by extracting
information from the current Java buffer.  The buffer is *not*
required to be in java-mode"
  (interactive)
  (setq ji-db (cl-reduce (lambda (db package)
                        (ji-packages-list-add-package db package))
                      (cons ji-db (ji-find-current-packages))))
  (unless (ji-timer-running ji-save-timer)
    (setq ji-save-timer (run-at-time "5 sec" nil #'ji-save-database))))

(defun ji-clear-database ()
  (interactive)
  (setq ji-db '()))

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

(defun ji-symbol-imported? (symbol)
  (if (-find (lambda (package)
               (member symbol (cdr package)))
             (ji-find-current-packages))
      t nil))

(defun ji-packages-for-symbol (db symbol)
  (-filter (lambda (package)
             (member symbol (cdr package)))
           db))

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

(defun ji-add (symbol)
  (interactive (list (symbol-name (symbol-at-point))))
  (if (ji-symbol-imported? symbol)
      (message "Already imported.")
    (ji-insert-import-stmt
     (completing-read "Package: " (mapcar (lambda (package)
                                            (concat (car package) "." symbol))
                                          (ji-packages-for-symbol ji-db symbol))))))

(provide 'java-import-db)
;;; java-import-db.el ends here
