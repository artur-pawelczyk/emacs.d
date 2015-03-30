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

(defmacro with-package-lazy (package &rest body)
  "Eval BODY after PAKCAGE is loaded.  Doesn't load package.
See `with-package'"
  (declare (indent 1))
  `(eval-after-load ,package
     (lambda () (progn
                  ,@body))))

(defmacro with-package (package &rest body)
  "Load PACKAGE and then eval BODY.
See `with-package-lazy'"
  (declare (indent 1))
  `(progn
     (with-package-lazy ,package ,@body)
     (require ,package nil :noerror)))

(defun conf/open-block (id action context)
  "Function to be used as a hook for Smartparens"
  (when (eq action 'insert)
    (save-excursion
      (newline)
      (indent-according-to-mode))))

(provide 'tools)
