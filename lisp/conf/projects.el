(when (require 'projectile nil 'noerror)
  (setq projectile-indexing-method 'alien)
  (projectile-global-mode))

(when (require 'helm-projectile nil 'noerror)
  (helm-projectile-on))


(provide 'conf/projects)
