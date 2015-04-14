(defvar conf/kill-sexp-function (if (require 'smartparens nil :noerror) #'sp-kill-sexp #'kill-sexp))
(make-local-variable 'conf/kill-sexp-function)

(defun conf/kill-sexp (&optional arg)
  (interactive "P")
  (funcall conf/kill-sexp-function arg))

(defvar conf/forward-slurp-function (when (require 'smartparens nil :noerror) #'sp-forward-slurp-sexp))
(make-local-variable 'conf/forward-slurp-function)

(defun conf/forward-slurp (&optional arg)
  (interactive "P")
  (funcall conf/forward-slurp-function arg))

(defun conf/enable-hybrid-exp ()
  (setq-local conf/kill-sexp-function #'sp-kill-hybrid-sexp)
  (setq-local conf/forward-slurp-function (lambda (&rest args) (sp-slurp-hybrid-sexp))))

(provide 'hybrid-exp)
