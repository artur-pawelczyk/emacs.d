(with-package (golden-ratio)
  (add-hook 'golden-ratio-mode-hook
            (lambda () (advice-add 'ace-window :after #'golden-ratio))))

(setq zoom-size '(0.618 . 0.618))

(with-package (zoom)
  (zoom-mode))
