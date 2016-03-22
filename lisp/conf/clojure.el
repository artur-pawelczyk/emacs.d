(setq cider-repl-pop-to-buffer-on-connect nil)

(defun conf/push-mark-before-jump (&rest args)
  (push-mark))

;; Save current point before jumping to var.
(with-package-lazy (cider)
  (advice-add #'cider-jump-to-var :before #'conf/push-mark-before-jump))

(with-package-lazy (cider-repl smartparens)
  (add-hook 'cider-repl-mode-hook #'smartparens-mode))

(provide 'conf/clojure)
