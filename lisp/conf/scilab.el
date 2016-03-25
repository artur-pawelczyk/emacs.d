(add-to-list 'auto-mode-alist '("\\.sci" . scilab-mode))
(add-to-list 'auto-mode-alist '("\\.sce" . scilab-mode))
(with-package-lazy (scilab)
  (define-key scilab-mode-map (kbd "C-n") nil))
