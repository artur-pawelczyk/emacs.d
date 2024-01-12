(with-package-lazy (go-mode)
  (define-key go-mode-map (kbd "C-c C-c C-t") #'go-test-current-file)
  (define-key go-mode-map (kbd "C-c C-c C-b") #'go-test-current-benchmark))
