;;; walk-undo -- preview "undo" changes without modifing the buffer

;;; Code:
(require 'cl-lib)

(defvar-local walk-undo-current-state 0)

(defvar-local walk-undo-original-buffer nil)

(defconst walk-undo-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "n") #'walk-undo-next)
    (define-key map (kbd "p") #'walk-undo-prev)
    (define-key map (kbd "q") #'quit-window)
    map))

(define-minor-mode walk-undo-mode "" nil " Walk undo" walk-undo-mode-map
  (if walk-undo-mode
      (setq buffer-read-only t)))

(defun walk-undo-prev ()
  (interactive)
  (cl-assert walk-undo-mode)
  (walk-undo-show-state walk-undo-original-buffer (1+ walk-undo-current-state)))

(defun walk-undo-next ()
  (interactive)
  (cl-assert walk-undo-mode)
  (unless (< walk-undo-current-state 1)
    (walk-undo-show-state walk-undo-original-buffer (1- walk-undo-current-state))))

(defun walk-undo-show-state (buffer n)
  (with-current-buffer (get-buffer-create "*walk-undo*")
    (setq walk-undo-current-state n)
    (setq walk-undo-original-buffer buffer)
    (let ((inhibit-read-only t))
      (erase-buffer)
      (insert (with-current-buffer buffer (buffer-string)))
      (setq buffer-undo-list (with-current-buffer buffer buffer-undo-list))
      (primitive-undo n buffer-undo-list))
    (walk-undo-mode 1))
  (pop-to-buffer "*walk-undo*"))

(defun walk-undo ()
  (interactive)
  (if (listp buffer-undo-list)
      (walk-undo-show-state (current-buffer) 0)
    (user-error "No undo information in the buffer")))

(provide 'walk-undo)
;;; walk-undo.el ends here
