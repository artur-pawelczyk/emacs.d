;; C-like languages (based on `cc-mode').

(with-package-lazy (cc-mode)
  ;; Semantic is a global mode.
  (semantic-mode 1))

(when (conf/installed-p 'ggtags)
  (add-hook 'c-mode-hook #'ggtags-mode))
