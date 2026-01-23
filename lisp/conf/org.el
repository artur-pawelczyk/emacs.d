(setq org-src-fontify-natively t)
(setq org-src-window-setup 'current-window)
(setq org-agenda-todo-ignore-scheduled 'all)
(setq org-blank-before-new-entry '((heading . t)
				   (plain-list-item . nil)))
(setq org-catch-invisible-edits 'show-and-error)
(setq org-special-ctrl-a/e t)
(setq org-special-ctrl-k t)

(with-package-lazy (org)
  (define-key org-mode-map (kbd "M-n") #'org-metadown)
  (define-key org-mode-map (kbd "M-p") #'org-metaup)
  (define-key org-mode-map (kbd "C-c >") #'org-metaright)
  (define-key org-mode-map (kbd "C-c <") #'org-metaleft))


(defun conf/org-goto-map--add-custom-keys ()
  (define-key org-goto-map (kbd "C-n") #'next-line)
  (define-key org-goto-map (kbd "C-p") #'previous-line))

(with-package-lazy (org)
  (advice-add 'org-goto-map :after #'conf/org-goto-map--add-custom-keys)
  (require 'org-tempo))

;; org-crypt
(with-package-lazy (org org-crypt)
  (org-crypt-use-before-save-magic)
  (add-to-list 'org-tags-exclude-from-inheritance "crypt"))

(with-package-lazy (org)
    (when (conf/installed-p 'org-bullets)
      (add-hook 'org-mode-hook #'org-bullets-mode)))

(with-package-lazy (org)
  (add-hook 'org-mode-hook #'org-indent-mode)
  (add-hook 'org-mode-hook (lambda ()
                             (add-hook 'before-save-hook #'conf/delete-trailing-whitespace-not-current-line nil :local))))

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(with-package-lazy (org)
  (when (boundp 'org-show-siblings)
    (add-to-list 'org-show-siblings '(org-goto . t))))


(with-package-lazy (org-agenda)
  (add-hook 'org-agenda-mode-hook #'hl-line-mode))


(with-package-lazy (org)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t))))

(defun conf/org-export-output-file-name (orig-fun extension &optional subtreep pub-dir)
  (let ((export-dir (if pub-dir
                        pub-dir
                      (ensure-directory "export"))))
    (apply orig-fun extension subtreep export-dir nil)))

(advice-add 'org-export-output-file-name :around #'conf/org-export-output-file-name)
