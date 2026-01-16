(require 'hydra)

(defun hydra-switch-window (arg)
  (interactive "P")
  (if (or arg (> (count-windows) 3))
      (call-interactively #'hydra-switch-window-dispatch/body)
    (call-interactively #'other-window)))

(defhydra hydra-switch-window-dispatch ()
  "Other window"
  ("h" windmove-left "←" :exit t)
  ("j" windmove-down "↓" :exit t)
  ("k" windmove-up "↑" :exit t)
  ("l" windmove-right "→" :exit t)
  ("d" hydra-switch-window-delete/body "delete" :exit t)
  ("s" hydra-switch-window-swap/body "swap" :exit t)
  ("o" other-window))

(defhydra hydra-switch-window-delete ()
  "Delete window"
  ("h" windmove-delete-left "←")
  ("j" windmove-delete-down "↓")
  ("k" windmove-delete-up "↑")
  ("l" windmove-delete-right "→"))

(defhydra hydra-switch-window-swap ()
  "Swap window"
  ("h" windmove-swap-states-left "←")
  ("j" windmove-swap-states-down "↓")
  ("k" windmove-swap-states-up "↑")
  ("l" windmove-swap-states-right "→"))

(provide 'hydra-switch-window)
