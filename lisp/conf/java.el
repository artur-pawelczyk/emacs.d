(require 'dash)

(add-hook 'java-mode-hook #'conf/enable-electric-pair)

(when (conf/installed-p 'ggtags)
  (add-hook 'java-mode-hook #'ggtags-mode))

(with-package-lazy (cc-mode)
  (define-key java-mode-map (kbd "C-c .") #'semantic-ia-fast-jump)
  (define-key java-mode-map (kbd "C-c i") #'ji-add))


(with-package-lazy (smartparens)
  (sp-local-pair 'java-mode "{" "}" :post-handlers '(:add conf/open-block) :unless '(sp-in-string-p))
  (sp-local-pair 'java-mode "\"" "\"" :unless '(sp-in-string-p))
  (sp-local-pair 'java-mode "/*" "*/"))


(defun conf/file-name->package (file-name)
  (string-join (->> (split-string file-name "/")
                    (-drop-while (lambda (e) (not (equal "java" e))))
                    cdr
                    -butlast)
               "."))

(provide 'conf/java)
