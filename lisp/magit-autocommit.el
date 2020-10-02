(require 'magit-mode)
(require 'magit-apply)
(require 'magit-process)
(require 'magit-sequence)

(defvar magit-autocommit-machine-id (system-name))

(defun magit-autocommit-can-amend (desired-message)
  (equal desired-message (car (magit-git-lines "log" "--pretty=%s" "@{upstream}..HEAD"))))

(defun magit-autocommit-prevented-p ()
  (or magit-autocommit-global-prevent-mode
      (magit-cherry-pick-in-progress-p)
      (magit-am-in-progress-p)
      (magit-revert-in-progress-p)
      (magit-sequencer-in-progress-p)
      (magit-bisect-in-progress-p)
      (magit-rebase-in-progress-p)))

(defun magit-autocommit (&optional dir)
  (let ((default-directory (or dir default-directory)))
    (unless (magit-autocommit-prevented-p)
      (magit-save-repository-buffers :force)
      (magit-stage-1 "--all")
      (let ((message (format "Autocommit on %s" magit-autocommit-machine-id)))
        (with-temp-message message
          (magit-run-git "commit" "-m" message
                         (when (magit-autocommit-can-amend message) "--amend")))))))

(defvar magit-autocommit-timer nil)
(defvar magit-autocommit-timeout 5)

(defun magit-autocommit-schedule ()
  (when (timerp magit-autocommit-timer)
    (cancel-timer magit-autocommit-timer))
  (setq magit-autocommit-timer
        (run-with-idle-timer magit-autocommit-timeout nil #'magit-autocommit default-directory)))

;;;###autoload
(define-minor-mode magit-autocommit-mode "Commit to the repository after saving a buffer"
  :lighter " AutoC"
  :global nil
  (if magit-autocommit-mode
      (add-hook 'after-save-hook #'magit-autocommit-schedule :append :local)
    (remove-hook 'after-save-hook #'magit-autocommit-schedule :local)))

;;;###autoload
(define-minor-mode magit-autocommit-global-prevent-mode
  "Temporarly disable magit-autocommit-mode."
  :global t)
