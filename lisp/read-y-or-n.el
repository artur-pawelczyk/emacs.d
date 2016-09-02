;; -*- mode: emacs-lisp; lexical-binding: t -*-

(defun read-letter-command (char)
  (lambda ()
    (interactive)
    (setq this-command 'read-y-or-n)
    (throw 'response char)))

(defvar read-letter-map
      (let ((map (make-sparse-keymap)))
        (set-keymap-parent map minibuffer-local-map)
        (cl-loop for char from ?A to ?z
                 do (let ((key (byte-to-string char)))
                      (define-key map key (read-letter-command key))))
        map))

(defvar read-y-or-n-original (symbol-function 'y-or-n-p))
(defvar read-yes-or-no-original (symbol-function 'yes-or-no-p))

(defun read-letter (prompt)
  "Read a single letter from minibuffer."
  (catch 'response
    (read-from-minibuffer prompt "" read-letter-map)))

(defun read-y-or-n (prompt)
  "Read \"y or n\" from miniubffer.
Like `y-or-n-p', but uses minibuffer instead of `read-key'."
  (let* ((prompt-with-space (concat prompt (if (string-suffix-p " " prompt) "" " ")))
         (resp (read-letter prompt-with-space)))
    (cond
     ((equal resp "y")
      t)
     ((equal resp "n")
      nil)
     (t
      (read-y-or-n (concat prompt " (answer 'y' or 'n') "))))))

(define-minor-mode read-y-or-n-mode
  "Read 'yes' or 'no' from minibuffer"
  :global t
  (if read-y-or-n-mode
      (progn
        (fset 'y-or-n-p #'read-y-or-n)
        (fset 'yes-or-no-p #'read-y-or-n))
    (fset 'y-or-n-p read-y-or-n-original)
    (fset 'yes-or-no-p read-yes-or-no-original)))
