(defun malabar-current-project-compile (command)
  (set-buffer (find-file-noselect (malabar-find-project-file)))
  (compile command))

(defun malabar-current-project-test ()
  (interactive)
  (malabar-current-project-compile "mvn test"))

(defun malabar-current-project-install ()
  (interactive)
  (malabar-current-project-compile "mvn install"))

(provide 'malabar-tools)
