(setq projectile-indexing-method 'alien)
(setq projectile-switch-project-action #'projectile-dired)


(defun conf/projectile-helm-functionality ()
  "Use some functions for `helm-projectile' even if it is not enabled."
  (define-key projectile-command-map (kbd "s s") #'helm-projectile-ag))

(with-package (projectile)
  (projectile-global-mode)
  (global-set-key (kbd "C-x p") projectile-command-map)
  (when (package-installed-p 'helm-projectile)
    (conf/projectile-helm-functionality)))

(defvar helm-projectile-hook nil)

(defun helm-projectile--after-toggle (toggle &rest other)
  (run-hooks 'helm-projectile-hook))

(advice-add 'helm-projectile-toggle :after #'helm-projectile--after-toggle)

(add-hook 'helm-projectile-hook (lambda ()
                                  (setq projectile-switch-project-action #'projectile-dired)))

(add-hook 'helm-projectile-hook #'conf/projectile-helm-functionality)


(defun display-startup-screen--enable-projectile (&rest args)
  (projectile-mode t))

(advice-add #'display-startup-screen :after #'display-startup-screen--enable-projectile)

(provide 'conf/projects)
