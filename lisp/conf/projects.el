(setq projectile-indexing-method 'alien)
(setq projectile-switch-project-action #'projectile-commander)


(defun projectile-ag-regex ()
    (interactive)
    (let ((current-prefix-arg t))
      (call-interactively #'projectile-ag)))

(with-package (projectile)
  (projectile-global-mode)
  (global-set-key (kbd "C-c p") projectile-command-map)
  (global-set-key (kbd "C-x p") projectile-command-map)
  (define-key projectile-command-map (kbd "s s") #'projectile-ag-regex))


(defvar helm-projectile-hook nil)

(defun helm-projectile--after-toggle (toggle &rest other)
  (run-hooks 'helm-projectile-hook))

(with-package-lazy (helm-projectile)
  (advice-add 'helm-projectile-toggle :after #'helm-projectile--after-toggle)
  (add-hook 'helm-projectile-hook (lambda ()
                                    (setq projectile-switch-project-action #'projectile-commander)))
  (add-hook 'helm-projectile-hook #'conf/projectile-helm-functionality))


(defun display-startup-screen--enable-projectile (&rest args)
  (when (conf/installed-p 'projectile)
    (projectile-mode t)))

(advice-add #'display-startup-screen :after #'display-startup-screen--enable-projectile)
