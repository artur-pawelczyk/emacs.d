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

(provide 'conf/basic-editing)