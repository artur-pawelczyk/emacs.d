(defun conf/smartparens-setup-keys ()
  (define-key sp-keymap (kbd "C-M-k") #'sp-kill-hybrid-sexp)
  (define-key sp-keymap (kbd "C-M-t") #'sp-transpose-hybrid-sexp)
  (define-key sp-keymap (kbd "C-}") #'sp-slurp-hybrid-sexp)
  (define-key sp-keymap (kbd "C-{") #'sp-push-hybrid-sexp))

(eval-after-load "smartparens" #'conf/smartparens-setup-keys)

(provide 'conf/prog)
