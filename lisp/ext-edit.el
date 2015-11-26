;;; ext-edit --- edit region in other buffer

;;; Commentary:
;;; Call `ext-edit-region' to edit region in other buffer.  C-x C-s to
;;; finish.

;;; Code:

(require 'dash)

(defvar ext-edit-origin-overlay nil
  "Overlay poining to the text being edited.")
(make-local-variable 'ext-edit-origin-overlay)


(defun ext-edit-transfer-to-origin ()
  "Move contents of the temporary buffer to the original buffer."
  (interactive)
  (let ((new-contents (buffer-substring (point-min) (point-max)))
        (overlay ext-edit-origin-overlay))
    (setq ext-edit-origin-overlay (with-current-buffer (overlay-buffer overlay)
                                    (save-excursion
                                      (let ((start (overlay-start overlay))
                                            (end (overlay-end overlay)))
                                        (delete-region start end)
                                        (delete-overlay overlay)
                                        (goto-char start)
                                        (insert new-contents)
                                        (make-overlay start (point))))))))

(defun ext-edit-commit ()
  "Finish editing in the temporary buffer."
  (interactive)
  (ext-edit-transfer-to-origin)
  (delete-overlay ext-edit-origin-overlay)
  (kill-buffer))

(defun ext-edit-save ()
  "Move the contents and save the original buffer."
  (interactive)
  (ext-edit-transfer-to-origin)
  (with-current-buffer (overlay-buffer ext-edit-origin-overlay)
    (save-buffer))
  (set-buffer-modified-p nil))

(defvar ext-edit-mode-map (make-sparse-keymap))

(define-minor-mode ext-edit-mode
  "Minor mode for editor temporary buffer.  It is always set up
automatically"
  nil
  "Ext edit"
  ext-edit-mode-map)

(define-key ext-edit-mode-map (kbd "C-c C-c") #'ext-edit-commit)
(define-key ext-edit-mode-map (kbd "C-x C-s") #'ext-edit-save)

(defun ext-edit-region (&optional mode)
  "Edit the region in a tempoaray buffer using the MODE."
  (interactive "CMajor mode: ")
  (let* ((origin-buffer-name (buffer-name))
         (editor-buffer-name (format "*%s-part*" origin-buffer-name))
         (contents (buffer-substring (mark) (point)))
         (overlay (make-overlay (mark) (point))))
    (deactivate-mark)
    (overlay-put overlay 'ext-edit editor-buffer-name)
    (switch-to-buffer-other-window (generate-new-buffer editor-buffer-name))
    (insert contents)
    (when mode
      (funcall mode))
    (ext-edit-mode)
    (setq ext-edit-origin-overlay overlay)))


(provide 'ext-edit)
;;; ext-edit.el ends here
