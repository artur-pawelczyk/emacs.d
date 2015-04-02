(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook #'subword-mode)

                                     
(with-package-lazy 'js2-mode
  (define-key js2-mode-map (kbd "M-.") #'conf/imenu))

(with-package 'smartparens
  (sp-local-pair 'js2-mode "{" "}" :post-handlers '(:add conf/open-block))
  (with-package-lazy 'js2-mode
    (add-hook 'js2-mode-hook (lambda () (setq conf/kill-sexp-function #'sp-kill-hybrid-sexp)))))

(provide 'conf/javascript)
