(defun conf/push-mark-before-jump (&rest args)
  (push-mark))

;; Save current point before jumping to var.
(with-package-lazy (cider)
  (advice-add #'cider-jump-to-var :before #'conf/push-mark-before-jump))

(provide 'conf/clojure)
