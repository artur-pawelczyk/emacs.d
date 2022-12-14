(with-package-lazy (jedi)
  (setq jedi:setup-keys t)
  (setq jedi:complete-on-dot t)
  (setq jedi:environment-virtualenv
        (append python-environment-virtualenv '("--python" "python3"))))

(when (conf/installed-p 'jedi)
  (add-hook 'python-mode-hook #'jedi:setup)
  (add-hook 'python-mode-hook #'jedi:ac-setup))

(add-hook 'python-mode-hook (lambda ()
			      (setq show-trailing-whitespace t)
			      (set-fill-column 80)))
