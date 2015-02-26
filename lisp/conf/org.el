(add-hook 'org-mode-hook (lambda ()
                           (local-set-key (kbd "M-n") #'org-metadown)
                           (local-set-key (kbd "M-p") #'org-metaup)))

(provide 'conf/org)
