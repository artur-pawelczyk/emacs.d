;; -*- mode: emacs-lisp; lexical-binding: t

(require 'subword)
(require 'cl)
(require 's)

(defun kill-word-or-region (arg)
  (interactive "p")
  (if mark-active
      (call-interactively #'kill-region (list (point) (mark)))
    (if subword-mode
        (subword-backward-kill (or arg 1))
      (backward-kill-word (or arg 1)))))

(defun eshell-copy-output ()
  "Kill all output from interpreter since last input.
Does not delete the prompt."
  (interactive)
  (save-excursion
    (goto-char (eshell-beginning-of-output))
    (insert "*** output flushed ***\n")
    (kill-region (point) (eshell-end-of-output))))

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

(defun upcase-first-char (str)
  (if (= (length str) 0)
      str
    (let ((first (substring str 0 1))
          (rest (substring str 1)))
      (concat (upcase first) rest))))

(defun javadoc-at-point ()
  (interactive)
  (let ((name-to-find (projectile-symbol-at-point)))
    (browse-url (format "http://duckduckgo.com/?q=!java+%s" name-to-find))))



(defvar diff-region--buffer-a-name "*diff-region-A*")
(defvar diff-region--buffer-b-name "*diff-region-B*")

(defun diff-region-start ()
  (interactive)
  (when (use-region-p)
    (let ((buffer (get-buffer-create diff-region--buffer-a-name)))
      (with-current-buffer buffer
        (erase-buffer))
      (append-to-buffer buffer (region-beginning) (region-end)))))

(defun diff-region-end ()
  (interactive)
  (when (use-region-p)
    (let ((buffer-a (get-buffer-create diff-region--buffer-a-name))
          (buffer-b (get-buffer-create diff-region--buffer-b-name)))
      (with-current-buffer buffer-b
        (erase-buffer))
      (append-to-buffer buffer-b (region-beginning) (region-end))
      (ediff-buffers buffer-a buffer-b))))

(defmacro with-package-lazy (packages &rest body)
  "Eval BODY after PACKAGES are loaded.  Don't load the packages.
See `with-package'"
  (declare (indent 1))
  (assert (and (listp packages) (not (eq (car packages) 'quote))))
  (let ((after-load (if (cdr packages)
                        (list `(with-package-lazy ,(cdr packages) ,@body))
                       body)))
    `(eval-after-load ',(car packages)
       (lambda () (progn
                    ,@after-load)))))

(defmacro with-package (packages &rest body)
  "Load PACKAGES and then eval BODY.
See `with-package-lazy'"
  (declare (indent 1))
  (let ((require-stmt (mapcar (lambda (p)
                                `(require ',p nil :noerror)) packages)))
    `(progn
       (with-package-lazy ,packages ,@body)
       ,@require-stmt)))

(defmacro after-init (&rest body)
  "Evaluate body on `after-init-hook'."
  `(add-hook 'after-init-hook (lambda () (progn ,@body))))

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
  (eq 'dired-mode (buffer-major-mode buffer-or-name)))

(defun update (what to e)
  "To be used with `mapcar'.

(mapcar (-partial #'update :b :x) '(:a :b :c)) => '(:a :x :c)"
  (if (eq e what)
      to
    e))

(defun comp (a b)
  "Function composition."
  (lambda (&rest args) (funcall a (apply b args))))

(defun constantly (value)
  "Always return VALUE."
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
