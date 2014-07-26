(add-hook 'java-mode-hook (lambda ()
 			    (semantic-mode)
                            (subword-mode)
                            (electric-indent-mode)
			    (show-paren-mode)
			    (define-key java-mode-map (kbd "M-/") 'semantic-complete-symbol) 
			    (define-key java-mode-map (kbd "M-.") 'semantic-ia-fast-jump)
                            (c-set-style "java")
			    ))

(add-to-list 'load-path (user-file "lisp/malabar/lisp"))

(provide 'conf/java)
