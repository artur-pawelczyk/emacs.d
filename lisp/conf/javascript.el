(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(with-package-lazy (js2-mode)
  (define-key js2-mode-map (kbd "M-.") #'conf/imenu))
