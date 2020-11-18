;; C-like languages (based on `cc-mode').

(setq semantic-default-submodes nil)

(when (conf/installed-p 'ggtags)
  (add-hook 'c-mode-hook #'ggtags-mode))
