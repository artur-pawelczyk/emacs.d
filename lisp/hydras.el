(require 'hydra)

(defhydra hydras-magit
  (:exit t :pre (require 'magit nil :noerror))
  "Magit"
  ("b" magit-blame)
  ("l" magit-log-popup)
  ("L" magit-log-buffer-file)
  ("v" magit-status)
  ("c" magit-branch-popup)
  ("f" magit-find-file)
  ("s" magit-show-commit)
  ("w" magit-wip-log-current)
  ("W" magit-wip-commit))

(defhydra hydras-page-movement
  (:hint nil)
  "Page movement"
  ("[" backward-page)
  ("]" forward-page))

(defun hydras-backward-page ()
  (interactive)
  (backward-page)
  (hydras-page-movement/body))

(defun hydras-forward-page ()
  (interactive)
  (forward-page)
  (hydras-page-movement/body))

(provide 'hydras)
