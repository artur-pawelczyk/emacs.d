;; -*- mode: emacs-lisp; lexical-binding: t -*-

(require 's)
(require 'dash)

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

(defun call-process-return-output (cmd &rest args)
  (with-temp-buffer
    (apply #'call-process cmd nil t nil args)
    (buffer-substring (point-min) (1- (point-max)))))

(defun buffer-major-mode (buffer-or-name)
  (with-current-buffer buffer-or-name
    major-mode))

(defun buffer-visible-p (buffer)
  (member buffer (mapcar #'window-buffer (window-list))))

(defvar cleanup-old-buffers--time 60)

(defun cleanup-old-buffers--touch (buffer)
  (with-current-buffer buffer
    (unless buffer-display-time
      (setq buffer-display-time (current-time)))
    buffer-display-time))

(defun cleanup-old-buffers ()
  "Kill every shell buffer that:
- has no running process,
- hasn't been viewed in `cleanup-old-buffers--time' seconds."
  (interactive)
  (let* ((time-constraint (time-subtract (current-time) cleanup-old-buffers--time))
         (candidates (-filter (lambda (buffer)
                                (and (memq (buffer-major-mode buffer) '(shell-mode term-mode ag-mode compilation-mode))
                                     (not (get-buffer-process buffer))))
                              (buffer-list)))
         (old-buffers (-filter (lambda (b)
                                 (let ((last-viewed (cleanup-old-buffers--touch b)))
                                   (not (time-less-p time-constraint last-viewed))))
                               candidates)))
    (mapcar #'kill-buffer old-buffers)
    (message "Killed %s buffers" (length old-buffers))
    old-buffers))

(defun delete-frame-if-only ()
  (interactive)
  (let* ((graphical-frames (-filter (lambda (f) (not (eq (framep f) t))) (frame-list)))
         (but-current (delete (window-frame) graphical-frames)))
    (if (null but-current)
        (when (y-or-n-p "Delete the only graphical frame? ")
          (delete-frame))
      (delete-frame))))

(defun clone-indirect-buffer-in-place ()
  "Like `clone-indirect-buffer' but always in the current window."
  (interactive)
  (let ((display-buffer-alist '((".*" . (display-buffer-same-window)))))
    (call-interactively #'clone-indirect-buffer)))

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

(defun find-nearest-directory (root name)
  (let ((regexp (concat "^" name "$")))
    (-last #'file-directory-p
           (directory-files-recursively root regexp :include-dirs))))

(defun ask-advice (fn &rest args)
  (when (y-or-n-p (format "About to run %s. Proceed?" real-this-command))
    (apply fn args)))

(defun conf/delete-trailing-whitespace-not-current-line ()
  "Like `delete-trailing-whitespace', but omit current line."
  (let ((start (save-excursion (beginning-of-line) (point)))
        (end (save-excursion (end-of-line) (point))))
    (delete-trailing-whitespace (point-min) start)
    (delete-trailing-whitespace end (point-max))))

(defun conf/copy-raw ()
  (interactive)
  (let ((content (buffer-substring-no-properties (mark) (point)))
        (fill-column most-positive-fixnum))
    (with-temp-buffer
      (insert content)
      (fill-region (point-min) (point-max))
      (kill-new (buffer-substring (point-min) (point-max))))))

(defmacro with-open-file (file &rest body)
  `(with-temp-file ,file
     (insert-file-contents ,file)
     ,@body))

(provide 'tools)
