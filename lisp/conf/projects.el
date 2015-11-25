(setq projectile-indexing-method 'alien)
(setq projectile-switch-project-action #'projectile-dired)


(defun projectile-ag-regex ()
    (interactive)
    (let ((current-prefix-arg t))
      (call-interactively #'projectile-ag)))

(with-package (projectile)
  (projectile-global-mode)
  (global-set-key (kbd "C-x p") projectile-command-map)
  (define-key projectile-command-map (kbd "s s") #'projectile-ag-regex))


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
