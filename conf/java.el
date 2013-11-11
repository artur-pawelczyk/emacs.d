(add-hook 'java-mode-hook (lambda ()
 			    (semantic-mode)
                            (require 'malabar-mode)
                            (add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))
                            (setq malabar-groovy-lib-dir (user-file "lisp/malabar/lib"))
			    (show-paren-mode)
			    (define-key java-mode-map (kbd "M-/") 'semantic-complete-symbol) 
			    (define-key java-mode-map (kbd "M-.") 'semantic-ia-fast-jump)
			    ))

(add-to-list 'load-path (user-file "lisp/malabar/lisp"))

(provide 'conf/java)
