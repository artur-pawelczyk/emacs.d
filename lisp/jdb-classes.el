(defvar jdb-classes nil)

(defun jdb-filter-breakpoint (output)
  (when (equal "** classes list **" (car output))
    (setq jdb-classes (cdr output))))

(add-to-list 'jdb-filters #'jdb-filter-breakpoint)

(defun jdb-classes-insert ()
  (interactive)
  (insert (completing-read "Java class: " jdb-classes)))

(defvar jdb-classes-completion-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-M-i") #'jdb-classes-insert)
    map))

(define-minor-mode jdb-classes-completion-mode ""
  :global nil
  :keymap jdb-classes-completion-map
  jdb-classes-completion-mode)

(provide 'jdb-classes)
