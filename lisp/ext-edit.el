;;; ext-edit --- edit region in other buffer

;;; Commentary:
;;; Call `ext-edit-region' to edit region in other buffer.  C-x C-s to
;;; finish.

;;; Code:

(require 'dash)

(defvar ext-edit-mode-map (make-sparse-keymap))

(defvar ext-edit-origin-buffer
  "Name of the buffer that `ext-edit-region' was invoked from")
(make-local-variable 'ext-edit-origin-buffer)
  


(define-minor-mode ext-edit-mode
  "Minor mode for editor temporary buffer.  It is always set up
automatically"
  nil
  "Ext edit"
  ext-edit-mode-map)
    
(defun ext-edit--overlay? (overlay)
  "Is the OVERLAY an overlay used by the package"
  (and overlay
       (plist-get (overlay-properties overlay) 'ext-edit)))

(defun ext-edit--find-overlay (buffer)
  "Find overlays in the BUFFER that corespond to the package."
  (with-current-buffer buffer
    (let* ((all-overlays (car (overlay-lists))))
      (car (-filter #'ext-edit--overlay? all-overlays)))))
      
  
(defun ext-edit-save-to-origin ()
  "Finish editing in the temporary buffer."
  (interactive)
  (let ((new-contents (buffer-substring (point-min) (point-max)))
        (overlay (ext-edit--find-overlay (get-buffer ext-edit-origin-buffer))))
    (with-current-buffer ext-edit-origin-buffer
      (save-excursion
        (let ((start (overlay-start overlay))
              (end (overlay-end overlay)))
        (delete-region start end)
        (goto-char start)
        (insert new-contents)
        (delete-overlay overlay))))
    (kill-buffer)))



(define-key ext-edit-mode-map (kbd "C-x C-s") #'ext-edit-save-to-origin)

(defun ext-edit-region ()
  "Edit the region in a tempoaray buffer."
  (interactive)
  (let* ((origin-buffer-name (buffer-name))
         (editor-buffer-name (format "*%s-part*" origin-buffer-name))
         (contents (buffer-substring (mark) (point)))
         (overlay (make-overlay (mark) (point))))
    (overlay-put overlay 'ext-edit editor-buffer-name)
    (switch-to-buffer-other-window (get-buffer-create editor-buffer-name))
    (insert contents)
    (ext-edit-mode t)
    (setq ext-edit-origin-buffer origin-buffer-name)))


(provide 'ext-edit)
;;; ext-edit.el ends here
