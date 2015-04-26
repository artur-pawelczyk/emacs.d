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

(defun ace-window-relative (arg)
  "Wraps call to `ace-window' so when key other than digit is
used, it calls `windmove-select-by-key'"
  (interactive "P")
  (condition-case err
      (ace-window arg)
    (user-error
     (windmove-select-by-key (caddr err)))))

(provide 'ace-window-relative)
