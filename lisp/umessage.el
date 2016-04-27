;;; umessage.el -- unobstructive `message' -*- lexical-binding: t -*-

;;; Commentary:
;; Display messages above the minibuffer.

(require 'simple)
(require 'subr-x)

(defun umessage--make-window-bottom ()
  (let ((ignore-window-parameters t))
    (split-window (frame-root-window) -1 'below)))

(defun umessage--new-window (buffer)
  (let ((w (umessage--make-window-bottom)))
    (set-window-parameter w 'no-other-window t)
    (set-window-buffer w buffer)
    (set-window-dedicated-p w t)
    w))

(defun umessage--new-buffer (name)
  (with-current-buffer (generate-new-buffer name)
    (setq mode-line-format nil)
    (setq cursor-type nil)
    (setq window-size-fixed t)
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
  (let* ((buffer (umessage--new-buffer " *umessage*"))
         (win (umessage--new-window buffer)))
    (with-current-buffer buffer
      (erase-buffer)
      (insert message))
    (run-at-time (or duration 5) nil (lambda ()
                                       (when (and (windowp win) (window-valid-p win))
                                         (delete-window win))
                                       (when (bufferp buffer)
                                         (kill-buffer buffer))))))

(defun umessage-around-message (fun &rest args)
  (if (and args (car args) (window-minibuffer-p))
      (let ((message (apply #'format-message args)))
        (when (not (string-empty-p message))
          (umessage message)))
    (apply fun args)))

(define-minor-mode umessage-mode ""
  :global t
  (if umessage-mode
      (advice-add 'message :around #'umessage-around-message)
    (advice-remove 'message #'umessage-around-message)))

(provide 'umessage)
