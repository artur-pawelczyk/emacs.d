(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(with-package-lazy (js2-mode)
  (define-key js2-mode-map (kbd "M-.") #'conf/imenu))

(with-package-lazy (smartparens js2-mode)
  (sp-local-pair 'js2-mode "{" "}" :post-handlers '(:add conf/open-block))
  (add-hook 'js2-mode-hook #'conf/enable-hybrid-exp))

(provide 'conf/javascript)
