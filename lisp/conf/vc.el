(require 'dash)

(define-key vc-prefix-map "e" #'vc-ediff)

(with-package-lazy (vc-dir)
  (define-key vc-dir-mode-map "e" #'vc-ediff))


;; Magit key bindings
(with-package-lazy (magit)
  (define-key magit-status-mode-map (kbd "M-u") #'magit-section-up))

(with-package-lazy (magit-diff)
  (define-key magit-revision-mode-map (kbd "M-u") #'magit-section-up))

(with-package-lazy (magit-log)
  (let* ((new-entry '(?d "Sort by date" "--date-order"))
         (new-list (cons new-entry (plist-get magit-log-popup :switches))))
    (setq magit-log-popup (plist-put magit-log-popup :switches new-list))))

(with-package-lazy (magit-log)
  (let* ((new-entry '(?m "No merges" "--no-merges"))
         (new-list (cons new-entry (plist-get magit-log-popup :switches))))
    (setq magit-log-popup (plist-put magit-log-popup :switches new-list))))


(with-package-lazy (magit)
  (magit-wip-after-save-mode 1))


(defun conf/magit-switch-to-buffer (buffer)
  "Display Magit status buffer in the same window"
  (if (eq (with-current-buffer buffer major-mode) 'magit-status-mode)
      (progn
        (switch-to-buffer buffer)
        (selected-window))
    (magit-display-buffer-traditional buffer)))

(setq magit-display-buffer-function #'conf/magit-switch-to-buffer)
(setq magit-display-buffer-noselect nil)

(add-to-list 'savehist-additional-variables 'log-edit-comment-ring)

(provide 'conf/vc)
