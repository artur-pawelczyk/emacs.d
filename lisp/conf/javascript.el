(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook #'subword-mode)

                                     
(with-package-lazy 'js2-mode
  (define-key js2-mode-map (kbd "M-.") #'conf/imenu))

(with-package 'smartparens
  (add-hook 'java-mode-hook #'smartparens-strict-mode)
  (sp-local-pair 'js2-mode "{" "}" :post-handlers '(:add conf/open-block)))

(provide 'conf/javascript)
