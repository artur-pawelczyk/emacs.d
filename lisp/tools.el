(defun kill-word-or-region ()
  (interactive)
  (if mark-active
      (kill-region (point) (mark))
    (backward-kill-word 1)))

(provide 'tools)
