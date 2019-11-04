(with-package (golden-ratio)
  (add-hook 'golden-ratio-mode-hook
            (lambda () (advice-add 'ace-window :after #'golden-ratio))))
