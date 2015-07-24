(add-hook 'java-mode-hook #'subword-mode)
(add-hook 'java-mode-hook #'ggtags-mode)
(add-hook 'java-mode-hook #'semantic-mode)

(with-package-lazy (cc-mode)
  (define-key java-mode-map (kbd "C-c .") #'semantic-ia-fast-jump))

(with-package (smartparens)
  (sp-local-pair 'java-mode "{" "}" :post-handlers '(:add conf/open-block) :unless '(sp-in-string-p))
  (sp-local-pair 'java-mode "\"" "\"" :unless '(sp-in-string-p))
  (sp-local-pair 'java-mode "/*" "*/")
  (add-hook 'java-mode-hook #'conf/enable-hybrid-exp))


(defun conf/current-java-package-name ()
  (semantic-tag-name (-find (lambda (tag)
                              (eq 'package (semantic-tag-class tag)))
                            (semantic-fetch-tags))))

(defun conf/current-java-full-class-name ()
  (let ((package-name (conf/current-java-package-name))
        (class-name (semantic-tag-name (semantic-current-tag-parent))))
    (concat package-name "." class-name)))

(defun conf/current-java-method-name ()
  (let ((full-class-name (conf/current-java-full-class-name))
        (method-name (semantic-tag-name (semantic-current-tag))))
    (concat full-class-name "." method-name)))

(defun conf/jdb-stop-in-method ()
  (interactive (cl-assert (eq major-mode 'java-mode)))
  (gud-call (format "stop in %s" (conf/current-java-method-name))))

(defun conf/jdb-stop-at-point ()
  "Set a breakpoint at current location in jdb.  Use when no
source information if available in jdb process."
  (interactive (cl-assert (eq major-mode 'java-mode)))
  (gud-call (format "stop at %s:%s" (conf/current-java-full-class-name) (line-number-at-pos))))

(provide 'conf/java)
