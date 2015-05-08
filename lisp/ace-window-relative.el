(require 'windmove)
(require 'ace-window)

(defun windmove-select-by-key (key)
  "Move to another window using hjkl keys."
  (interactive "c")
  (case key
    (?k (windmove-up))
    (?j (windmove-down))
    (?h (windmove-left))
    (?l (windmove-right))))

(defun windmove-find-by-key (key)
  (let ((dir (case key
               (?k 'up)
               (?j 'down)
               (?h 'left)
               (?l 'right))))
    (windmove-find-other-window dir)))

(defun ace-window-relative (arg)
  "Wraps call to `ace-window' so when key other than digit is
used, it calls `windmove-select-by-key'"
  (interactive "p")
  (condition-case err
      (ace-window arg)
    (user-error
     (let ((key (caddr err)))
       (case arg
         (4 (aw-swap-window (windmove-find-by-key key)))
         (16 (aw-delete-window (windmove-find-by-key key)))
         (t (windmove-select-by-key key)))))))

(provide 'ace-window-relative)
