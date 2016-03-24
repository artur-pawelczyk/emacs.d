(require 'dash)
(require 'dash-functional)
(require 'hydra)
(require 'windmove)

(defun conf/find-window-no-minibuf (dir)
  (let ((wind (windmove-find-other-window dir)))
    (if (eq (active-minibuffer-window) wind)
        nil
      wind)))

(defun conf/window-corner ()
  (let ((windmove-wrap-around nil))
    (-filter (-not #'conf/find-window-no-minibuf) '(left right up down))))

(defun conf/resize-window (dir)
  (let* ((n (or current-prefix-arg 1))
         (-n (* -1 n)))
    (cond
     ((memq dir '(up down))
      (enlarge-window (if (memq dir (conf/window-corner)) -n n)))
     ((memq dir '(left right))
      (enlarge-window-horizontally (if (memq dir (conf/window-corner)) -n n))))))

(defhydra hydra-resize-window (:pre (setq linum-mode-suppress-update t)
                                 :post (setq linum-mode-suppress-update nil))
  "Resize window"
  ("h" (conf/resize-window 'left))
  ("j" (conf/resize-window 'down))
  ("k" (conf/resize-window 'up))
  ("l" (conf/resize-window 'right))
  ("RET" nil)
  ("" nil))

(provide 'hydra-resize-window)
