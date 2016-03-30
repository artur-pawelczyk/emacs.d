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

(provide 'hydras)
