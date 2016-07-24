(defun background-shell-command ()
  "Run `async-shell-command' but don't display the subprocess's buffer."
  (interactive)
  (let ((display-buffer-alist '((".*" . (display-buffer-no-window)))))
    (call-interactively #'async-shell-command)))

(defun background-dired-shell-command ()
  "Run `dired-do-async-shell-command' but don't display the subprocess's buffer."
  (interactive)
  (let ((display-buffer-alist '((".*" . (display-buffer-no-window)))))
    (call-interactively #'dired-do-async-shell-command)))

(global-set-key (kbd "M-!") #'background-shell-command)

(with-package-lazy (dired)
  (define-key dired-mode-map (kbd "!") #'background-dired-shell-command)
  (define-key dired-mode-map (kbd "M-!") #'background-shell-command))


;; Print the output of asynchronous command to the minibuffer
(defconst shell-command-sentinel--max-output 100)

(defun shell-command-sentinel--get-output (buffer)
  (with-current-buffer buffer
    (let* ((end (point-max))
           (start (- end shell-command-sentinel--max-output))
           (beg (if (> start 0) start 1)))
      (buffer-substring beg end))))

(defun shell-command-sentinel--print-output (fun process signal)
  (if (and (eq (process-status process) 'exit)
           (not (buffer-visible-p (process-buffer process))))
      (let ((command (car (last (process-command process))))
            (output (shell-command-sentinel--get-output (process-buffer process))))
        (message "command \"%s\" finished: %s" command (string-trim output)))
    (funcall fun process signal)))

(advice-add 'shell-command-sentinel :around #'shell-command-sentinel--print-output)
