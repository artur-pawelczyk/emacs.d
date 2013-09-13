(defun kill-word-or-region ()
  (interactive)
  (if mark-active
      (kill-region (point) (mark))
    (backward-kill-word 1)))

(defun try-load-pymacs ()
  (if (eq (require 'pymacs nil t) 'pymacs)
      (pymacs-load "ropemacs" "rope-")))

(provide 'tools)
