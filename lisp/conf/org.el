(setq org-modules '(org-bbdb org-bibtex org-crypt org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m))

(with-package-lazy (org)
  (define-key org-mode-map (kbd "M-n") #'org-metadown)
  (define-key org-mode-map (kbd "M-p") #'org-metaup))

(setq org-src-fontify-natively t)

(with-package-lazy (org helm)
  (define-key org-mode-map (kbd "C-c C-j") #'helm-org-headlines))

;; org-crypt
(with-package-lazy (org org-crypt)
  (org-crypt-use-before-save-magic)
  (add-to-list 'org-tags-exclude-from-inheritance "crypt"))

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(provide 'conf/org)
