(defun kill-word-or-region ()
  (interactive)
  (if mark-active
      (kill-region (point) (mark))
    (backward-kill-word 1)))

(defun load-custom-file-if-exists ()
  (if (file-exists-p custom-file)
      (load custom-file)))

(defun try-load-pymacs ()
  (if (eq (require 'pymacs nil t) 'pymacs)
      (pymacs-load "ropemacs" "rope-")))

(provide 'tools)
