;; Replace on all visible text, not only after point.
(defun query-replace--act-on-all (orig from to &optional delimited start end &rest args)
  (let ((beg (if mark-active (mark) (point-min)))
        (end (if mark-active (point) (point-max))))
    (apply orig from to delimited beg end args)))

(advice-add 'query-replace :around #'query-replace--act-on-all)
(advice-add 'query-replace-regexp :around #'query-replace--act-on-all)

(with-package-lazy (elec-pair)
  (unless (fboundp 'electric-pair-local-mode)
    (make-variable-buffer-local 'electric-pair-mode)))


(defun conf/enable-electric-pair ()
  (interactive)
  (if (fboundp 'electric-pair-local-mode)
      (electric-pair-local-mode 1)
    (electric-pair-mode 1)))


(defun isearch-symbol-case-sensitive ()
  (interactive)
  (let ((case-fold-search nil))
    (isearch-forward-symbol-at-point)))

(global-set-key (kbd "M-s .") #'isearch-symbol-case-sensitive)


(with-package (subword)
  (global-subword-mode))


(define-key occur-mode-map (kbd "n") #'next-error-no-select)
(define-key occur-mode-map (kbd "p") #'previous-error-no-select)


(when (conf/installed-p 'avy)
  (define-key isearch-mode-map (kbd "C-'") #'avy-isearch))
