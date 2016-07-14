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
