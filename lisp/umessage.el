;;; umessage.el --- unobstructive `message' -*- lexical-binding: t -*-

;; Version: 0.1

;;; Commentary:
;; Display messages above the minibuffer.

(require 'simple)
(require 'subr-x)

(defconst umessage--format-function
  (if (fboundp 'format-message)
      #'format-message
    #'format))

(defun umessage--make-window-bottom (height)
  (let ((ignore-window-parameters t))
    (split-window (frame-root-window) (- height) 'below)))

(defconst umessage-window-max-height 5)

(defun umessage--window-height (buffer)
  (let ((lines (with-current-buffer buffer (count-lines (point-min) (point-max)))))
    (if (> lines umessage-window-max-height)
      umessage-window-max-height
    (if (< lines 1)
        1
      lines))))

(defun umessage--new-window (buffer)
  "Make a temporary window for BUFFER.
Height of the window is just enough to fit BUFFER's content, but
smaller than `umessage-window-max-height'."
  (let ((w (umessage--make-window-bottom (umessage--window-height buffer))))
    (set-window-parameter w 'no-other-window t)
    (set-window-buffer w buffer)
    (set-window-dedicated-p w t)
    w))

(defun umessage--new-buffer (name content)
  (with-current-buffer (generate-new-buffer name)
    (setq mode-line-format nil)
    (setq cursor-type nil)
    (setq window-size-fixed t)
    (erase-buffer)
    (insert content)
    (goto-char (point-min))
    (current-buffer)))

(defun umessage-log-only (message)
  "Insert MESSAGE into *Messages* buffer."
  (with-current-buffer (messages-buffer)
    (let ((inhibit-read-only t))
      (goto-char (point-max))
      (insert ?\n message ?\n))))

(defun umessage-view-only (message &optional duration)
  (let* ((buffer (umessage--new-buffer " *umessage*" message))
         (win (umessage--new-window buffer)))
    (run-at-time (or duration 5) nil (lambda ()
                                       (when (and (windowp win) (window-valid-p win))
                                         (delete-window win))
                                       (when (bufferp buffer)
                                         (kill-buffer buffer))))))

;;;###autoload
(defun umessage (message &optional duration)
  "Display MESSAGE in special buffer above the minibuffer for DURATION of seconds."
  (umessage-log-only message)
  (umessage-view-only message duration))

(defun umessage-format-error (data context &optional fun)
  (let ((msg (error-message-string data))
        (context-string (when (and (stringp "") (not (string-empty-p context))) context))
        (fun-string (when (and fun (symbolp fun)) (symbol-name fun))))
    (string-join (remove-if-not #'identity (list context-string fun-string msg)) ": ")))

(defun umessage-command-error (data context fun)
  (if (window-minibuffer-p)
      (progn
        (umessage-log-only (umessage-format-error data context fun))
        (umessage-view-only (umessage-format-error data context)))
    (command-error-default-function data context fun)))

(defun umessage-around-message (fun &rest args)
  (if (and args (car args) (window-minibuffer-p))
      (let ((message (apply umessage--format-function args)))
        (when (not (string-empty-p message))
          (umessage message)))
    (apply fun args)))

;;;###autoload
(define-minor-mode umessage-mode ""
  :global t
  (if umessage-mode
      (progn
        (advice-add 'message :around #'umessage-around-message)
        (setq command-error-function #'umessage-command-error))
    (advice-remove 'message #'umessage-around-message)
    (setq command-error-function #'command-error-default-function)))

(provide 'umessage)
;;; umessage.el ends here
