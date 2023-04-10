(setq org-babel-tangle-use-relative-file-links nil)
(setq org-agenda-todo-ignore-timestamp 'all)
(setq org-enforce-todo-dependencies t)

(with-package (org-capture)
  (add-to-list 'org-capture-templates `("t" "Todo" entry
                                        (file ,(format "~/org/inbox-%s.org" system-name))
                                        "* TODO %?\n%U"))
  (add-to-list 'org-capture-templates '("T" "Old-style todo" entry
                                        (file+headline "~/org/notes.org" "Inbox")
                                        "* TODO %?\n%U"))
  (add-to-list 'org-capture-templates '("e" "Event" entry
                                        (file+headline "~/org/notes.org" "Inbox")))
  (add-to-list 'org-capture-templates '("z" "Shopping list item" item
                                        (file+headline "~/org/notes.org" "Shopping list"))))

(setq org-refile-targets '((nil :maxlevel . 9)
                           (org-agenda-files :maxlevel . 1)))
