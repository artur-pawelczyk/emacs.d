;; -*- mode: emacs-lisp; lexical-binding: t -*-

(defun read-letter-command (char)
  (lambda ()
    (interactive)
    (throw 'response char)))

(defvar read-letter-map
      (let ((map (make-sparse-keymap)))
        (set-keymap-parent map minibuffer-local-map)
        (cl-loop for char from ?A to ?z
                 do (let ((key (byte-to-string char)))
                      (define-key map key (read-letter-command key))))
        map))

(defun read-letter (prompt)
  "Read a single letter from minibuffer."
  (catch 'response
    (read-from-minibuffer prompt "" read-letter-map)))

(defun read-y-or-n (prompt)
  "Read \"y or n\" from miniubffer.
Like `y-or-n-p', but uses minibuffer instead of `read-key'."
  (let ((resp (read-letter prompt)))
    (cond
     ((equal resp "y")
      t)
     ((equal resp "n")
      nil)
     (t
      (read-y-or-n (concat prompt " (answer 'y' or 'n') "))))))

(defun read-y-or-n-setup ()
  "Replace the default \"y or n\" prompt with `read-y-or-n'"
  (interactive)
  (fset 'y-or-n-p #'read-y-or-n)
  (fset 'yes-or-no-p #'read-y-or-n))
