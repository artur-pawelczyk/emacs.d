(require 'format-spec)
(require 'json)

(defvar polish-radio-default-program "2")

(defvar polish-radio-schedule-url-format "http://apipr.polskieradio.pl/api/schedule?Program=%p&SelectedDate=%d")

(defvar polish-radio-response-buffer "*polish-radio-response*")

(defun polish-radio-get-entry-seq (response)
  (cdr (assoc 'Schedule response)))

(defun polish-radio-insert-spacer ()
  (insert "\n\f\n"))

(defun polish-radio-entry-get (entry field)
  (or (cdr (assoc field entry)) ""))

(defun polish-radio-insert-entry (entry)
  (insert "Title: " (polish-radio-entry-get entry 'Title))
  (insert "\n")
  (insert "From: " (polish-radio-entry-get entry 'StartHour))
  (insert "\n")
  (insert "To: " (polish-radio-entry-get entry 'StopHour))
  (insert "\n")
  (insert (polish-radio-entry-get entry 'Description)))

(defun polish-radio-display-response (json)
  (with-current-buffer (get-buffer-create polish-radio-response-buffer)
    (let ((inhibit-read-only t))
      (erase-buffer)
      (save-excursion
        (mapc (lambda (e)
                (polish-radio-insert-entry e)
                (polish-radio-insert-spacer))
              (polish-radio-get-entry-seq json))
        (goto-char (point-min))
        (view-mode 1))))
  (display-buffer polish-radio-response-buffer))

(defun polish-radio-handler (&rest args)
  (polish-radio-display-response (plist-get args :data)))

(defun polish-radio-read-date ()
  (if (fboundp 'org-read-date)
      (org-read-date nil nil nil "Schedule for day: ")
    (read-from-minibuffer "Schedule for day: ")))

(defun polish-radio-for-day (date)
  (interactive (list (polish-radio-read-date)))
  (if (string-match "[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}" date)
      (let ((url (format-spec polish-radio-schedule-url-format `((?p . ,polish-radio-default-program)
                                                                 (?d . ,date)))))
        (polish-radio-display-response (with-temp-buffer
                                         (url-insert-file-contents url)
                                         (json-read))))
    (user-error "Date must match yyyy-mm-dd")))

(provide 'polish-radio)
