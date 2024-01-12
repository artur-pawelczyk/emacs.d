(with-package-lazy (em-hist)
  (if (conf/installed-p 'counsel)
      (define-key eshell-hist-mode-map (kbd "M-r") #'counsel-esh-history)))
