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

(defun conf/shell-non-command? (name)
  (and (string-match-p "^[A-Z_]+=.+$" name) t))

(defvar conf/shell-extended-commands '("nohup" "git"))

(defun conf/shell-extended-command? (name)
  (member name conf/shell-extended-commands))

(defun conf/shell-command-unique-name (command)
  (or (car (-drop-while (-partial #'conf/shell-non-command?) (split-string command " ")))
      command))

(defun conf/shell-command-buffer-name (command)
  (let ((parts (-drop-while (-partial #'conf/shell-non-command?) (split-string command))))
    (string-join (append (-take-while #'conf/shell-extended-command? parts)
                         (list (car (-drop-while #'conf/shell-extended-command? parts))))
                 "-")))

(defun conf/shell-new-buffer-name (command)
  (let ((base-name (format "*%s: shell-command*" (conf/shell-command-buffer-name command))))
    (generate-new-buffer-name base-name)))

(defun async-shell-command--set-buffer-name (orig-fun command &optional orig-buffer error-buffer)
  (let ((buffer-name (conf/shell-new-buffer-name command)))
    (if orig-buffer
        (funcall orig-fun command orig-buffer error-buffer)
      (funcall orig-fun command buffer-name buffer-name))))

(define-minor-mode shell-command-print-output-mode
  "Print output of asychronous command to the minibuffer"
  :lighter nil
  (if shell-command-print-output-mode
      (advice-add 'shell-command-sentinel :around #'shell-command-sentinel--print-output)
    (advice-remove 'shell-command-sentinel #'shell-command-sentinel--print-output)))

(define-minor-mode shell-command-rename-buffer-mode ""
  :ligher nil
  (if shell-command-rename-buffer-mode
      (advice-add 'shell-command :around #'async-shell-command--set-buffer-name)
    (advice-remove 'shell-command #'async-shell-command--set-buffer-name)))

(provide 'shell-command)
