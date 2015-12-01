;; Replace on all visible text, not only after point.

(defun query-replace--act-on-all (orig from to &optional delimited start end backward)
  (let ((beg (if mark-active (mark) (point-min)))
        (end (if mark-active (point) (point-max))))
    (funcall orig from to delimited beg end backward)))

(advice-add 'query-replace :around #'query-replace--act-on-all)
(advice-add 'query-replace-regexp :around #'query-replace--act-on-all)

(provide 'conf/basic-editing)
