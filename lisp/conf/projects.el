(with-package-lazy (projectile)
  (projectile-mode t)
  (require 'project)
  (setq project-find-functions (delq 'project-try-vc project-find-functions)))

(setq projectile-indexing-method 'alien)
(setq projectile-switch-project-action #'projectile-commander)
(when (conf/installed-p 'ivy)
  (setq projectile-completion-system 'ivy))


(defun projectile-search-regex ()
    (interactive)
    (let ((current-prefix-arg t))
      (call-interactively #'projectile-ripgrep)))

(defun conf/projectile-relevant-known-projects ()
    projectile-known-projects)

(with-package (projectile)
  (fset 'projectile-relevant-known-projects #'conf/projectile-relevant-known-projects)
  (projectile-global-mode)
  (global-set-key (kbd "C-c p") projectile-command-map)
  (global-set-key (kbd "C-x p") projectile-command-map)
  (define-key projectile-command-map (kbd "s s") #'projectile-search-regex))


;; Compilation
(defun conf/projectile-compilation-name (default)
  (let ((project-name (projectile-project-name)))
    (if (equal project-name "-")
        (format "*%s*" default)
      (format "*%s: %s*" default project-name))))

(defun conf/projectile-run-compilation (cmd &optional use-comint-mode)
  "Run external or Elisp compilation command CMD."
  (if (functionp cmd)
      (funcall cmd)
    (compilation-start cmd nil #'conf/projectile-compilation-name)))

(with-package-lazy (projectile)
  (fset 'projectile-run-compilation 'conf/projectile-run-compilation))


;; Shell command
(defun conf/projectile-background-shell-command ()
  (interactive)
  (let ((default-directory (projectile-project-root))
        (display-buffer-alist '((".*" . (display-buffer-no-window)))))
    (call-interactively #'async-shell-command)))

(with-package-lazy (projectile)
  (define-key projectile-command-map "!" #'conf/projectile-background-shell-command))


;; Searching

;; Silver searcher: this just doesn't work
(setq ag-group-matches nil)

;; ripgrep
(with-package-lazy (ripgrep)
  (define-key ripgrep-search-mode-map (kbd "n") #'next-error-no-select)
  (define-key ripgrep-search-mode-map (kbd "p") #'previous-error-no-select))
