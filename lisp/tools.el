(require 'subword)

(defun kill-word-or-region ()
  (interactive)
  (if mark-active
      (kill-region (point) (mark))
    (if subword-mode
        (subword-backward-kill 1)
        (backward-kill-word 1))))

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

(defun zap-to-char-exclusive (char)
  (interactive (list
                (read-char "Zap to char: " t)))
  (zap-to-char 1 char)
  (insert char)
  (backward-char))

(defun clear-line-annotations ()
  (interactive)
  (replace-regexp "//\s*[0-9]+" "")
  (delete-trailing-whitespace))

(defun annotate-lines-regexp (regexp)
  (interactive (list (read-string "Annotate regexp: ")))
  (save-excursion
  (let ((next-number 0))
    (while (search-forward-regexp regexp)
      (move-end-of-line nil)
      (comment-indent)
      (setq next-number (1+ next-number))
      (insert (number-to-string next-number))))))

(defun downcase-first-char (str)
  (if (= (length str) 0)
      str
    (let ((first (substring str 0 1))
          (rest (substring str 1)))
      (concat (downcase first) rest))))

(provide 'tools)
