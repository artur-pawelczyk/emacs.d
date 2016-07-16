;;; umessage.el -- unobstructive `message' -*- lexical-binding: t -*-

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

(defun umessage (message &optional duration)
  "Display MESSAGE in special buffer above the minibuffer for DURATION of seconds."
  (umessage-log-only message)
  (let* ((buffer (umessage--new-buffer " *umessage*" message))
         (win (umessage--new-window buffer)))
    (run-at-time (or duration 5) nil (lambda ()
                                       (when (and (windowp win) (window-valid-p win))
                                         (delete-window win))
                                       (when (bufferp buffer)
                                         (kill-buffer buffer))))))

(defun umessage-around-message (fun &rest args)
  (if (and args (car args) (window-minibuffer-p))
      (let ((message (apply umessage--format-function args)))
        (when (not (string-empty-p message))
          (umessage message)))
    (apply fun args)))

(define-minor-mode umessage-mode ""
  :global t
  (if umessage-mode
      (advice-add 'message :around #'umessage-around-message)
    (advice-remove 'message #'umessage-around-message)))

(provide 'umessage)
