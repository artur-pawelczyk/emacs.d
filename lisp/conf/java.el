(require 'cc-mode)

(add-hook 'java-mode-hook (lambda ()
                            (ggtags-mode)
                            (subword-mode)))

(define-key java-mode-map (kbd "C-c j") #'conf/imenu)

(provide 'conf/java)
