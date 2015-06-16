(add-hook 'java-mode-hook #'subword-mode)

(add-hook 'java-mode-hook #'ggtags-mode)

(with-package-lazy (cc-mode)
  (define-key java-mode-map (kbd "C-c j") #'conf/imenu))

(with-package (smartparens)
  (sp-local-pair 'java-mode "{" "}" :post-handlers '(:add conf/open-block) :unless '(sp-in-string-p))
  (sp-local-pair 'java-mode "\"" "\"" :actions '(insert wrap) :unless '(sp-in-string-p))
  (add-hook 'java-mode-hook #'conf/enable-hybrid-exp))

(provide 'conf/java)
