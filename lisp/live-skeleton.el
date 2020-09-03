;;; live-skeleton --- skeletons with live preview
;;; -*- mode: emacs-lisp; lexical-binding: t

;;; Commentary:
;; skeletons with live preview

;;; Code:
(require 'dash)

(defvar live-skeleton-current-overlay nil)

(defvar live-skeleton-current nil)

(defvar live-skeleton-skeletons nil)

(defun live-skeleton-replace-in-overlay (overlay text)
  "Replace the text in OVERLAY with TEXT.
Return a new overlay over the new text."
  (with-current-buffer (overlay-buffer overlay)
    (goto-char (overlay-start overlay))
    (delete-region (overlay-start overlay) (overlay-end overlay))
    (insert text)
    (make-overlay (overlay-start overlay) (point))))

(defun live-skeleton-expanstion-state (skeleton)
  (-replace-where #'stringp (-const "") skeleton))

(defun live-skeleton-next-state (state text)
  (-replace-first "" text state))

(defun live-skeleton-print-state (state)
  (apply (car state) (cdr state)))

(defun live-skeleton-minibuffer-after-insert ()
  "A `post-command-hook' for minibuffer."
  (when (minibufferp (current-buffer))
    (let ((new-text (live-skeleton-print-state (live-skeleton-next-state live-skeleton-current (minibuffer-contents)))))
      (setq live-skeleton-current-overlay
            (live-skeleton-replace-in-overlay live-skeleton-current-overlay new-text)))))

(defun live-skeleton-minibuffer-quit ()
  (interactive)
  (when (overlayp live-skeleton-current-overlay)
    (live-skeleton-replace-in-overlay live-skeleton-current-overlay ""))
  (minibuffer-keyboard-quit))

(defvar live-skeleton-minibuffer-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-g") #'live-skeleton-minibuffer-quit)
    map))

(defun live-skeleton-read ()
  (assoc (intern (completing-read "Skeleton: " (mapcar #'car live-skeleton-skeletons))) live-skeleton-skeletons))

(defun live-skeleton (skeleton)
  (interactive (list (live-skeleton-read)))
  (setq live-skeleton-current-overlay (make-overlay (point) (point)))
  (setq live-skeleton-current (live-skeleton-expanstion-state skeleton))
  (unwind-protect
      (progn
        (add-hook 'post-command-hook #'live-skeleton-minibuffer-after-insert)
        (dotimes (i (1- (length live-skeleton-current)))
          (setq live-skeleton-current
                (live-skeleton-next-state live-skeleton-current
                                          (read-from-minibuffer "Skeleton: " ""
                                                                (make-composed-keymap live-skeleton-minibuffer-keymap minibuffer-local-map))))))
    (remove-hook 'post-command-hook #'live-skeleton-minibuffer-after-insert)))

(defun live-skeleton-default (val default)
  (if (and val (not (string-empty-p val)))
      val
    default))


;; Example skeletons
(defun live-skeleton-example (var val)
  (format "(setq %s %s)" var val))

(add-to-list 'live-skeleton-skeletons '(live-skeleton-example "var" "val"))

(provide 'live-skeleton)
