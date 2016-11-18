(require 'tools)
(require 'dash)
(require 'subr-x)

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

(defun shell-command-non-command? (name)
  (and (string-match-p "^[A-Z_]+=.+$" name) t))

(defvar shell-command-extended-commands '("nohup" "git"))

(defun shell-command-extended-command? (name)
  (member name shell-command-extended-commands))

(defun shell-command-unique-name (command)
  (or (car (-drop-while (-partial #'shell-command-non-command?) (split-string command " ")))
      command))

(defun shell-command-buffer-name (command)
  (let* ((split (-drop-while (-partial #'shell-command-non-command?) (split-string command)))
         (base-names (mapcar #'file-name-base split)))
    (string-join (append (-take-while #'shell-command-extended-command? base-names)
                         (list (car (-drop-while #'shell-command-extended-command? base-names))))
                 "-")))

(defun shell-command-new-buffer-name (command)
  (let ((base-name (format "*%s: shell-command*" (shell-command-buffer-name command))))
    (generate-new-buffer-name base-name)))

(defun shell-command--set-buffer-name (orig-fun command &optional orig-buffer error-buffer)
  (let ((buffer-name (shell-command-new-buffer-name command)))
    (if orig-buffer
        (funcall orig-fun command orig-buffer error-buffer)
      (funcall orig-fun command buffer-name buffer-name))))

(define-minor-mode shell-command-print-output-mode
  "Print output of asychronous command to the minibuffer"
  :lighter nil
  :global t
  (if shell-command-print-output-mode
      (advice-add 'shell-command-sentinel :around #'shell-command-sentinel--print-output)
    (advice-remove 'shell-command-sentinel #'shell-command-sentinel--print-output)))

(define-minor-mode shell-command-rename-buffer-mode ""
  :lighter nil
  :global t
  (if shell-command-rename-buffer-mode
      (advice-add 'shell-command :around #'shell-command--set-buffer-name)
    (advice-remove 'shell-command #'shell-command--set-buffer-name)))

(defun shell-command-get-real-command (command)
  (if (and (string-suffix-p "bash" (car command)) (equal (cadr command) "-c"))
      (nthcdr 2 command)
    command))

(defvar-local shell-command-last-command nil)

(defun shell-command-save-command ()
  (let ((process (get-buffer-process (current-buffer))))
    (when process
      (setq-local shell-command-last-command (shell-command-get-real-command (process-command process))))))

(add-hook 'shell-mode-hook #'shell-command-save-command)

(defun shell-command-rerun (&optional edit)
  (interactive "P")
  (let ((async-shell-command-buffer 'confirm-kill-process)
        (command (string-join shell-command-last-command " ")))
    (if (not (string-empty-p command))
        (async-shell-command (if edit
                                 (read-shell-command "Run: " command)
                               command)
                             (buffer-name))
      (message "No command to run"))))

(defun shell-command-in-subshell (command)
  "Run COMMAND in a shell, so it's controlled by it and not by
  Emacs"
  (interactive (list (read-shell-command "Run in shell: ")))
  (let ((buffer (get-buffer-create (shell-command-new-buffer-name command))))
    (async-shell-command (getenv "SHELL") buffer)
    (comint-simple-send (get-buffer-process buffer) command)
    (comint-simple-send (get-buffer-process buffer) "exit")))

(defun shell-command-nohup (command)
  (interactive (list (read-shell-command "Run in shell: ")))
  (async-shell-command (concat "nohup " command)))

(defun shell-command-at-point ()
  (cond ((eq major-mode 'dired-mode)
         (let ((files (dired-get-marked-files)))
           (if (> 1 (length files))
               (user-error "Can run only single file")
             (car files))))
        (t
         (user-error "No program at point"))))

(defun shell-command-run-at-point (&optional edit)
  (interactive "P")
  (let ((command (shell-command-at-point)))
    (shell-command-nohup (if edit
                             (read-shell-command "Run: " command)
                           command))))


(provide 'shell-command)
