;; -*- mode: emacs-lisp; lexical-binding: t -*-

(require 'cl)
(require 's)

(defun kill-word-or-region (arg)
  (interactive "p")
  (if mark-active
      (call-interactively #'kill-region (list (point) (mark)))
    (backward-kill-word (or arg 1))))

(defun eshell-copy-output ()
  "Kill all output from interpreter since last input.
Does not delete the prompt."
  (interactive)
  (save-excursion
    (goto-char (eshell-beginning-of-output))
    (insert "*** output flushed ***\n")
    (kill-region (point) (eshell-end-of-output))))

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

(defun downcase-first-char (str)
  (if (= (length str) 0)
      str
    (let ((first (substring str 0 1))
          (rest (substring str 1)))
      (concat (downcase first) rest))))

(defun upcase-first-char (str)
  (if (= (length str) 0)
      str
    (let ((first (substring str 0 1))
          (rest (substring str 1)))
      (concat (upcase first) rest))))

(defun conf/open-block (id action context)
  "Function to be used as a hook for Smartparens"
  (when (eq action 'insert)
    (save-excursion
      (newline)
      (indent-according-to-mode))))

(defun call-process-return-output (cmd &rest args)
  (with-temp-buffer
    (apply #'call-process cmd nil t nil args)
    (buffer-substring (point-min) (1- (point-max)))))

(defun buffer-major-mode (buffer-or-name)
  (with-current-buffer buffer-or-name
    major-mode))

(defun shell-cleanup-dead-buffers ()
  "Kill all shell buffers that have no process running."
  (interactive)
  (mapcar (lambda (buffer)
            (when (and (eq 'shell-mode (buffer-major-mode buffer))
                       (not (get-buffer-process buffer)))
              (kill-buffer buffer)))
          (buffer-list)))

(defun buffer-major-mode (buffer-or-name)
  (with-current-buffer buffer-or-name
    major-mode))

(defun dired-buffer? (buffer-or-name)
  (when (get-buffer buffer-or-name)
    (eq 'dired-mode (buffer-major-mode buffer-or-name))))

(defun update (what to e)
  "To be used with `mapcar'.

(mapcar (-partial #'update :b :x) '(:a :b :c)) => '(:a :x :c)"
  (if (eq e what)
      to
    e))

(defun comp (a b)
  "Function composition."
  (warn "Function `comp' called. Use `-compose' instead")
  (lambda (&rest args) (funcall a (apply b args))))

(defun constantly (value)
  "Always return VALUE."
  (warn "Function `constantly' called. Use `-const' instead")
  (lambda (&rest args) value))

(defun return-ordered (&rest values)
  "Return function that takes n and gives (nth n VALUES)."
  (lambda (n)
    (nth n values)))

(defun conf/format-simple (format &rest values)
  "Replace $0...$n with VALUES."
  (s-format format (apply #'return-ordered values)))

(defun match-all-in-buffer (pattern buffer)
  (with-current-buffer buffer)
  (s-match-strings-all pattern (buffer-substring (point-min) (point-max))))

(provide 'tools)
