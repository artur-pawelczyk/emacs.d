(defvar conf/org-path "~/org")

(setq org-babel-tangle-use-relative-file-links nil)
(setq org-agenda-todo-ignore-timestamp 'all)
(setq org-enforce-todo-dependencies t)

(with-package-lazy (org)
  (add-to-list 'org-agenda-files conf/org-path))

(with-package-lazy (org-capture)
  (add-to-list 'org-capture-templates `("t" "Inbox" entry
                                        (file ,(format "%s/inbox-%s.org" conf/org-path system-name))
                                        "* NEW %?\n%U")))

(setq org-todo-keywords '((sequence "NEW" "NEXT(n)" "WAIT(w@)" "PROJ(p)" "|" "DONE(d)" "CNLD(c@)" "SOME(s!)")))

(with-package (org-faces)
  (add-to-list 'org-todo-keyword-faces '("NEW" . org-todo))
  (add-to-list 'org-todo-keyword-faces '("NEXT" . "red"))
  (add-to-list 'org-todo-keyword-faces '("WAIT" . "green"))
  (add-to-list 'org-todo-keyword-faces '("PROJ" . "yellow"))
  (add-to-list 'org-todo-keyword-faces '("DONE" . org-done))
  (add-to-list 'org-todo-keyword-faces '("CLND" . org-done))
  (add-to-list 'org-todo-keyword-faces '("SOME" . "orange")))

(setq org-refile-targets '((nil :maxlevel . 9)
                           (org-agenda-files :maxlevel . 1)))
