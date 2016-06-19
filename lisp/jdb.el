(require 'subr-x)
(require 'cl-lib)

(require 'java-parser)
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

(defun jdb-real-line-number ()
  (save-restriction
    (widen)
    (line-number-at-pos)))

(defun jdb-stop-in-method ()
  (interactive)
  (jdb-ensure-mode)
  (jdb-call (format "stop in %s" (java-full-method-at-point))))

(defun jdb-stop-at-point ()
  (interactive)
  (jdb-ensure-mode)
  (jdb-call (format "stop at %s:%s" (java-full-class-at-point) (jdb-real-line-number))))

(defun jdb-watch-field-at-point ()
  (interactive)
  (jdb-ensure-mode)
  (jdb-call (format "watch %s" (java-full-method-at-point))))

(defun jdb-clear-breakpoint (breakpoint)
  (interactive (list (completing-read "Breakpoint: " jdb-breakpoint-list)))
  (jdb-call (format "clear %s" breakpoint))
  (jdb-call "clear"))

(defun jdb-clear-all-breakpoints ()
  (interactive)
  (mapc #'jdb-clear-breakpoint jdb-breakpoint-list))

(provide 'jdb)
