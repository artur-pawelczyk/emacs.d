(defun conf/push-mark-before-jump (&rest args)
  (push-mark))

(defun conf/cider-apply-custom-advice ()
  (advice-add #'cider-jump-to-var :before #'conf/push-mark-before-jump))

;; Save current point before jumping to var.
(eval-after-load 'cider #'conf/cider-apply-custom-advice)

(provide 'conf/clojure)
