;; -*- mode: emacs-lisp; lexical-binding: t -*-

(require 'windmove)
(require 'ace-window)
(require 'cl-macs)

(defun ace-window-relative-direction (dir)
  "Return the window on DIR.  Ignore minibuffer."
  (let ((window (windmove-find-other-window dir)))
    (if (window-minibuffer-p window)
        nil
      window)))

(defun ace-window-relative-dispatcher (dir)
  "Return a dispatch handler for `aw-dispatch-alist' acting on a
neighbour window (DIR).  Requires lexical binding."
  (lambda ()
    (interactive)
    (cl-case aw-action
      (#'aw-switch-to-window
       (windmove-do-window-select dir))
      (#'aw-delete-window
       (aw-delete-window (ace-window-relative-direction dir)))
      (#'aw-swap-window (aw-swap-window (ace-window-relative-direction dir))))))

(defun ace-window-add-dispatch (kbd function)
  (let ((key (elt (kbd kbd) 0)))
    (add-to-list 'aw-dispatch-alist (list key function))))

(ace-window-add-dispatch "j"   (ace-window-relative-dispatcher 'down))
(ace-window-add-dispatch "M-j" (ace-window-relative-dispatcher 'down))
(ace-window-add-dispatch "k"   (ace-window-relative-dispatcher 'up))
(ace-window-add-dispatch "M-k" (ace-window-relative-dispatcher 'up))
(ace-window-add-dispatch "h"   (ace-window-relative-dispatcher 'left))
(ace-window-add-dispatch "M-h" (ace-window-relative-dispatcher 'left))
(ace-window-add-dispatch "l"   (ace-window-relative-dispatcher 'right))
(ace-window-add-dispatch "M-l" (ace-window-relative-dispatcher 'right))

(provide 'ace-window-relative)
