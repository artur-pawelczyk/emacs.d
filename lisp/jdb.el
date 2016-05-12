(require 'semantic)
(require 'subr-x)
(require 'cl-lib)

(require 'jdb-filters)
(require 'jdb-breakpoint)

(defvar jdb-pending-commands '())

(defun jdb-call (command)
  (if (get-buffer-process gud-comint-buffer)
      (gud-call command)
    (setq jdb-pending-commands (cons command jdb-pending-commands))))

(defun jdb-send-pending-commands ()
  (mapc #'gud-call jdb-pending-commands)
  (setq jdb-pending-commands '()))

(add-hook 'jdb-filters-ready-hook #'jdb-send-pending-commands)


(defun jdb-ensure-mode ()
  (cl-assert (eq major-mode 'java-mode))
  (semantic-mode 1))

(defun jdb-tag-at-point (&optional force-refresh)
  (when force-refresh
    (semantic-force-refresh))
  (or (semantic-find-tag-by-overlay)
      (when (y-or-n-p "Semantic information for found. Refresh?")
        (jdb-tag-at-point :force-refresh))))

(defun jdb-tag-package (tags)
  (semantic-tag-full-package (car tags)))

(defun jdb-tag-class (tags)
  (let* ((classes (-filter (lambda (tag) (equal "class" (semantic-tag-type tag))) tags))
         (names (mapcar #'semantic-tag-name classes)))
    (string-join (seq-uniq names) "$")))

(defun jdb-tag-method (tags)
  (semantic-tag-name (car (last tags))))

(defun jdb-current-method ()
  (let ((tags (jdb-tag-at-point)))
    (unless tags (error "No semantic information in the buffer."))
    (concat (jdb-tag-package tags)
             "."
             (jdb-tag-class tags)
             "."
             (jdb-tag-method tags))))

(defun jdb-current-class ()
  (let ((tags (jdb-tag-at-point)))
    (unless tags (error "No semantic information in the buffer."))
    (concat (jdb-tag-package tags)
            "."
            (jdb-tag-class tags))))

(defun jdb-real-line-number ()
  (save-restriction
    (widen)
    (line-number-at-pos)))

(defun jdb-stop-in-method ()
  (interactive)
  (jdb-ensure-mode)
  (jdb-call (format "stop in %s" (jdb-current-method))))

(defun jdb-stop-at-point ()
  (interactive)
  (jdb-ensure-mode)
  (jdb-call (format "stop at %s:%s" (jdb-current-class) (jdb-real-line-number))))

(defun jdb-watch-field-at-point ()
  (interactive)
  (jdb-ensure-mode)
  (jdb-call (format "watch %s" (jdb-current-method))))

(defun jdb-clear-breakpoint (breakpoint)
  (interactive (list (completing-read "Breakpoint: " jdb-breakpoint-list)))
  (jdb-call (format "clear %s" breakpoint))
  (jdb-call "clear"))

(defun jdb-clear-all-breakpoints ()
  (interactive)
  (mapc #'jdb-clear-breakpoint jdb-breakpoint-list))

(provide 'jdb)
