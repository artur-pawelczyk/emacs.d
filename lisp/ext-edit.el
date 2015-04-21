;;; ext-edit --- edit region in other buffer

;;; Commentary:
;;; Call `ext-edit-region' to edit region in other buffer.  C-x C-s to
;;; finish.

;;; Code:

(require 'dash)

(defvar ext-edit-origin-overlay nil
  "Overlay poining to the edited text.")
(make-local-variable 'ext-edit-origin-overlay)


(defun ext-edit-save-to-origin ()
  "Finish editing in the temporary buffer."
  (interactive)
  (let ((new-contents (buffer-substring (point-min) (point-max)))
        (overlay ext-edit-origin-overlay))
    (with-current-buffer (overlay-buffer overlay)
      (save-excursion
        (let ((start (overlay-start overlay))
              (end (overlay-end overlay)))
        (delete-region start end)
        (goto-char start)
        (insert new-contents)
        (delete-overlay overlay))))
    (kill-buffer)))


(defun ext-edit-region (&optional mode)
  "Edit the region in a tempoaray buffer using the MODE."
  (interactive "CMajor mode: ")
  (let* ((origin-buffer-name (buffer-name))
         (editor-buffer-name (format "*%s-part*" origin-buffer-name))
         (contents (buffer-substring (mark) (point)))
         (overlay (make-overlay (mark) (point))))
    (overlay-put overlay 'ext-edit editor-buffer-name)
    (switch-to-buffer-other-window (get-buffer-create editor-buffer-name))
    (insert contents)
    (when mode
      (funcall mode))
    (local-set-key (kbd "C-c C-c") #'ext-edit-save-to-origin)
    (setq ext-edit-origin-overlay overlay)))


(provide 'ext-edit)
;;; ext-edit.el ends here
