(require 'hydra)

(defun hydra-switch-window (arg)
  (interactive "P")
  (if (or arg (> (count-windows) 3))
      (call-interactively #'hydra-switch-window-dispatch/body)
    (call-interactively #'other-window)))

;; TODO: M-h, ...
(defhydra hydra-switch-window-dispatch (:exit t :hint nil)
  "
(M-)[_h_ _j_ _k_ _l_]: move [_s_]: swap, [_d_]: delete, (M-o)[_o_]: next
"
  ("h" windmove-left)
  ("j" windmove-down)
  ("k" windmove-up)
  ("l" windmove-right)
  ("M-h" windmove-left)
  ("M-j" windmove-down)
  ("M-k" windmove-up)
  ("M-l" windmove-right)
  ("d" hydra-switch-window-delete/body)
  ("s" hydra-switch-window-swap/body)
  ("o" other-window)
  ("M-o" other-window))

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
