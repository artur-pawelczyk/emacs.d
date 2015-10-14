(defun conf/vc-read-rev ()
  (let* ((backed (vc-responsible-backend default-directory))
         (current-rev (vc-working-revision default-directory backed))
         (message (format "Swith from '%s' to: " current-rev)))
    (if (and (eq backed 'Git) (fboundp 'magit-read-other-branch-or-commit))
        (magit-read-other-branch-or-commit message)
      (read-string message))))

(defun conf/vc-switch-branch (name)
  (interactive (list (conf/vc-read-rev)))
  (message "Switching to another branch")
  (vc-call-backend (vc-responsible-backend default-directory) 'retrieve-tag default-directory name nil)
  (message "Switching done"))

(define-key vc-prefix-map "e" #'vc-ediff)
(define-key vc-prefix-map "r" #'conf/vc-switch-branch)

(with-package-lazy (vc-dir)
  (define-key vc-dir-mode-map "e" #'vc-ediff))

(with-package-lazy (vc-dir magit)
  (define-key vc-dir-mode-map "l" #'magit-log-popup)
  (define-key vc-dir-mode-map "P" #'magit-push-popup)
  (define-key vc-dir-mode-map "b" #'magit-branch-popup)
  (define-key vc-dir-mode-map "d" #'magit-diff-working-tree)
  (define-key vc-dir-mode-map ":" #'magit-git-command)
  (define-key vc-dir-mode-map "$" #'magit-process))


;; Magit key bindings
(with-package-lazy (magit)
  (define-key magit-status-mode-map (kbd "M-u") #'magit-section-up))

(with-package-lazy (magit-diff)
  (define-key magit-revision-mode-map (kbd "M-u") #'magit-section-up))

;; Change hard to type `=p' binding to `=g':
;; FIXME: No longer necessary after version from Oct 1 2015 (commit
;; 47594337880049531a5471f463f116ca24e65cf6 in magit repo)
(with-package-lazy (magit-log)
    (setq magit-log-popup (-tree-map (-partial #'update ?p ?g) magit-log-popup)))


(with-package-lazy (magit)
  (magit-wip-after-save-mode 1)
  (magit-wip-before-change-mode 1))


(provide 'conf/vc)
