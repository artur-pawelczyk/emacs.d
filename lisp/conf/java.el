(require 'cc-mode)

(add-hook 'java-mode-hook #'subword-mode)

(with-package 'ggtags
  (add-hook 'java-mode-hook #'ggtags-mode))

(define-key java-mode-map (kbd "C-c j") #'conf/imenu)

(provide 'conf/java)
