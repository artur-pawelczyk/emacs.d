(require 'dash)

(define-key vc-prefix-map "e" #'vc-ediff)

(with-package-lazy (vc-dir)
  (define-key vc-dir-mode-map "e" #'vc-ediff))


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


(provide 'conf/vc)
