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

(defun kill-temp-buffer-current ()
  (interactive)
  (save-buffer)
  (kill-buffer)
  (delete-frame))

(defun input-form-find-file (filename)
  (find-file filename)
  (set-input-method "polish-slash")
  (ispell-change-dictionary "polish")
  (flyspell-mode)
  (local-set-key (kbd "C-c C-c") 'kill-temp-buffer-current))

(provide 'tools)
