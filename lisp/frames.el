;;; frames.el -- Convenience functions for handing frames

;;;; Commentary:
;;; Set of command for better handling of frames with less advanced
;;; window managers.  Default prefix is `C-z'.

;;; Code:

(defvar frames-map (make-sparse-keymap))

(defun frames-next ()
  "Switch to the next frame."
  (interactive)
  (let ((next-frame (next-frame (selected-frame))))
    (when next-frame
      (select-frame-set-input-focus next-frame))))

(defun frames-prev ()
  "Switch to the prevoius frame."
  (interactive)
  (let ((prev-frame (previous-frame (selected-frame))))
    (when prev-frame
      (select-frame-set-input-focus prev-frame))))

(autoload 'mouse-avoidance-banish "avoid")

(defun frames-banish-mouse ()
  (interactive)
  (mouse-avoidance-banish))

(global-set-key (kbd "C-z") frames-map)
(define-key frames-map (kbd "C-n") #'frames-next)
(define-key frames-map (kbd "C-p") #'frames-prev)
(define-key frames-map (kbd "c") #'make-frame-command)
(define-key frames-map (kbd "C-z") #'other-frame)
(define-key frames-map (kbd "k") #'delete-frame)
(define-key frames-map (kbd "C-b") #'frames-banish-mouse)

(provide 'frames)
;;; frames.el ends here
