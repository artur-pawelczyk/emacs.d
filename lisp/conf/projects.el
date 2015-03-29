(setq projectile-indexing-method 'alien)

(with-package 'projectile
  (projectile-global-mode))

(with-package 'helm-projectile
  (helm-projectile-on))

(provide 'conf/projects)
