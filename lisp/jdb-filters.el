(require 'dash)
(require 'dash-functional)
(require 'gud)
(require 's)
(require 'subr-x)

(defvar jdb-filters-last-output nil)
(defvar jdb-filters '())
(defvar jdb-filters-ready-hook nil)

(defconst jdb-filters-temp-buffer " *jdb-filters-tmp*")

(defun jdb-filters-split-output (output)
  (mapcar #'string-trim (split-string output "\n")))

(defun jdb-filters-output-end? (output)
  (or (string-match-p "^.*>[[:space:]]*$" output)
      (string-match-p "^.*\\[[0-9]+\\][[:space:]]*$" output)))

(defun jdb-filters-advice (output)
  (with-current-buffer (get-buffer-create jdb-filters-temp-buffer)
    (insert output)
    (when (jdb-filters-output-end? output)
      (setq jdb-filters-last-output (jdb-filters-split-output (buffer-string)))
      (erase-buffer)
      (run-hooks 'jdb-filters-ready-hook)))
  (mapc (-partial (-flip #'funcall) jdb-filters-last-output) jdb-filters))

(advice-add 'gud-jdb-marker-filter :after #'jdb-filters-advice)

(provide 'jdb-filters)
