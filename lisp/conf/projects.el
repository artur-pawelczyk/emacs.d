(setq projectile-indexing-method 'alien)

(with-package (projectile)
  (projectile-global-mode)
  (setq projectile-switch-project-action #'projectile-dired))

(with-package (helm-projectile)
  (helm-projectile-on))

(provide 'conf/projects)
