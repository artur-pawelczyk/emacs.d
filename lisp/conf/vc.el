(require 'dash)

;; Workaround for a Magit error
(require 'project)

(define-key vc-prefix-map "e" #'vc-ediff)
(setq magit-revision-filter-files-on-follow nil)

(with-package-lazy (vc-dir)
  (define-key vc-dir-mode-map "e" #'vc-ediff))


;; Magit key bindings
(with-package-lazy (magit)
  (define-key magit-status-mode-map (kbd "M-u") #'magit-section-up))

(with-package-lazy (magit-diff)
  (define-key magit-revision-mode-map (kbd "M-u") #'magit-section-up))

(with-package-lazy (magit-stash)
  (define-key magit-stash-mode-map (kbd "M-u") #'magit-section-up))


(defun conf/magit-switch-to-buffer (buffer)
  "Display Magit status buffer in the same window"
  (if (eq (with-current-buffer buffer major-mode) 'magit-status-mode)
      (progn
        (switch-to-buffer buffer)
        (selected-window))
    (magit-display-buffer-traditional buffer)))

(setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
(setq magit-display-buffer-noselect nil)

(add-to-list 'savehist-additional-variables 'log-edit-comment-ring)


;; Remove `magit-insert-unpushed-to-upstream' section of the status buffer.
(with-package-lazy (magit-status)
  (setq magit-status-sections-hook (mapcar (lambda (elem)
                                             (if (eq elem 'magit-insert-unpushed-to-upstream-or-recent)
                                                 #'magit-insert-unpushed-to-upstream
                                               elem))
                                           magit-status-sections-hook)))
