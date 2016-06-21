(setq projectile-indexing-method 'alien)
(setq projectile-switch-project-action #'projectile-commander)
(setq projectile-enable-caching t)
(when (conf/installed-p 'ivy)
  (setq projectile-completion-system 'ivy))


(defun projectile-ag-regex ()
    (interactive)
    (let ((current-prefix-arg t))
      (call-interactively #'projectile-ag)))

(defun conf/projectile-relevant-known-projects ()
    projectile-known-projects)

(with-package (projectile)
  (fset 'projectile-relevant-known-projects #'conf/projectile-relevant-known-projects)
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


;; Compilation
(defun conf/projectile-compilation-name (default)
  (let ((project-name (projectile-project-name)))
    (if (equal project-name "-")
        (format "*%s*" default)
      (format "*%s: %s*" default project-name))))

(defun conf/projectile-run-compilation (cmd)
  "Run external or Elisp compilation command CMD."
  (if (functionp cmd)
      (funcall cmd)
    (compilation-start cmd nil #'conf/projectile-compilation-name)))

(with-package-lazy (projectile)
  (fset 'projectile-run-compilation 'conf/projectile-run-compilation))
