(setq projectile-indexing-method 'alien)
(setq projectile-switch-project-action #'projectile-dired)

(with-package (projectile)
  (projectile-global-mode))

(with-package (helm-projectile)
  (helm-projectile-on))

(defvar helm-projectile-hook nil)

(defun helm-projectile--after-toggle (toggle &rest other)
  (run-hooks 'helm-projectile-hook))

(advice-add 'helm-projectile-toggle :after #'helm-projectile--after-toggle)

(add-hook 'helm-projectile-hook (lambda ()
                                  (setq projectile-switch-project-action #'projectile-dired)))

(provide 'conf/projects)
