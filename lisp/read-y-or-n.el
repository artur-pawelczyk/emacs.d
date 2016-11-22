;;; read-y-or-n.el --- "yes or no" prompt in minibuffer -*- lexical-binding: t -*-

;;; Version: 0.1

;;; Commentary
;; Replacement for `y-or-n-p' that uses the minibuffer instead of
;; `read-key'

(defvar read-y-or-n-original (symbol-function 'y-or-n-p))
(defvar read-yes-or-no-original (symbol-function 'yes-or-no-p))

(defun read-char-setup-hook ()
  (add-hook 'post-self-insert-hook (lambda ()
                                     (throw 'read-char-response last-command-event))
            nil :local))

(defun read-char-from-minibuffer (prompt)
  "Read a single char from minibuffer."
  (catch 'read-char-response
    (minibuffer-with-setup-hook #'read-char-setup-hook
      (read-from-minibuffer prompt))))


(defun read-y-or-n-prompt (prompt &optional help)
  (let ((parts (list prompt
                     (if help "(answer 'y' or 'n')" ""))))
    (concat (string-trim (string-join parts " ")) " ")))

;;;###autoload
(defun read-y-or-n (prompt &optional help)
  "Read \"y or n\" from miniubffer.
Like `y-or-n-p', but uses minibuffer instead of `read-key'."
  (let ((resp (read-char-from-minibuffer (read-y-or-n-prompt prompt help))))
    (cond
     ((equal resp ?y)
      t)
     ((equal resp ?n)
      nil)
     (t
      (read-y-or-n prompt :help)))))

;;;###autoload
(define-minor-mode read-y-or-n-mode
  "Read 'yes' or 'no' from minibuffer"
  :global t
  (if read-y-or-n-mode
      (progn
        (fset 'y-or-n-p #'read-y-or-n)
        (fset 'yes-or-no-p #'read-y-or-n))
    (fset 'y-or-n-p read-y-or-n-original)
    (fset 'yes-or-no-p read-yes-or-no-original)))


(provide 'read-y-or-n)
;;; read-y-or-n.el ends here
