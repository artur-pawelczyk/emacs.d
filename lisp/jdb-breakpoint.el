(require 's)
(require 'dash)

(require 'jdb-filters)

(defconst jdb-filters-breakpoint-pattern "breakpoint[[:space:]]+\\([.:A-z0-9$()]+\\)")

(defvar jdb-breakpoint-list nil)

(defun jdb-filters-extract-breakpoint (line)
  (-if-let (match (s-match jdb-filters-breakpoint-pattern line))
      (nth 1 match)))

(defun jdb-filter-breakpoint (output)
  (cond ((string-prefix-p "Breakpoints" (car output))
         (setq jdb-breakpoint-list (-filter #'identity (mapcar #'jdb-filters-extract-breakpoint (cdr output)))))
        ((string-prefix-p "No breakpoints" (car output))
         (setq jdb-breakpoint-list nil))))

(add-to-list 'jdb-filters #'jdb-filter-breakpoint)

(provide 'jdb-breakpoint)
