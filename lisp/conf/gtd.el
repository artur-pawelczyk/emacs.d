(setq org-babel-tangle-use-relative-file-links nil)
(setq org-agenda-todo-ignore-timestamp 'all)
(setq org-enforce-todo-dependencies t)

(with-package (org-capture)
  (add-to-list 'org-capture-templates `("t" "Inbox" entry
                                        (file ,(format "~/org/inbox-%s.org" system-name))
                                        "* NEW %?\n%U")))

(with-package (org-faces)
  (add-to-list 'org-todo-keyword-faces '("NEW" . org-todo))
  (add-to-list 'org-todo-keyword-faces '("NEXT" . org-todo))
  (add-to-list 'org-todo-keyword-faces '("WAIT" . org-todo))
  (add-to-list 'org-todo-keyword-faces '("PROJ" . org-todo))
  (add-to-list 'org-todo-keyword-faces '("DONE" . org-done))
  (add-to-list 'org-todo-keyword-faces '("CLND" . org-done))
  (add-to-list 'org-todo-keyword-faces '("SOME" . org-done)))

(setq org-refile-targets '((nil :maxlevel . 9)
                           (org-agenda-files :maxlevel . 1)))
