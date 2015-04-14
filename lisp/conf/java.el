(require 'cc-mode)

(add-hook 'java-mode-hook #'subword-mode)

(with-package 'ggtags
  (add-hook 'java-mode-hook #'ggtags-mode))

(define-key java-mode-map (kbd "C-c j") #'conf/imenu)

(with-package 'smartparens
  (sp-local-pair 'java-mode "{" "}" :post-handlers '(:add conf/open-block))
  (add-hook 'java-mode-hook #'conf/enable-hybrid-exp))

(provide 'conf/java)
