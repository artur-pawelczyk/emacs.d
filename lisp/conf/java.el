(add-hook 'java-mode-hook (lambda ()
 			    (semantic-mode)
                            (subword-mode)))

(provide 'conf/java)
