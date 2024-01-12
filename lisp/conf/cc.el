;; C-like languages (based on `cc-mode').

(when (conf/installed-p 'ggtags)
  (add-hook 'c-mode-hook #'ggtags-mode))

(with-package-lazy (ggtags)
  (define-key ggtags-mode-map (kbd "M-o") nil))
