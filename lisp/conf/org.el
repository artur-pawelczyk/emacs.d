(with-package-lazy (org)
  (define-key org-mode-map (kbd "M-n") #'org-metadown)
  (define-key org-mode-map (kbd "M-p") #'org-metaup))

(setq org-src-fontify-natively t)

(provide 'conf/org)
