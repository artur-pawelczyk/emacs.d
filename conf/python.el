(require 'conf/rope)
(require 'conf/jedi)

(add-hook 'python-mode-hook (lambda ()
			      (setq show-trailing-whitespace t)
			      (set-fill-column 80)
			      (auto-fill-mode t)
			      (subword-mode t)))

(provide 'conf/python)
