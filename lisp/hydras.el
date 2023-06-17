(require 'hydra)

(defhydra hydras-magit
  (:exit t :pre (require 'magit nil :noerror))
  "Magit"
  ("b" magit-blame)
  ("l" magit-log)
  ("L" magit-log-buffer-file)
  ("v" magit-status)
  ("c" magit-branch)
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


(defhydra hydras-org-block-movement
  (:hint nil)
  "Org block movement"
  ("M-f" org-next-block)
  ("M-b" org-previous-block))

(defun hydras-org-next-block ()
  (interactive)
  (org-next-block 1)
  (hydras-org-block-movement/body))

(defun hydras-org-previous-block ()
  (interactive)
  (org-previous-block 1)
  (hydras-org-block-movement/body))


(defhydra hydras-home
  (global-map "C-c h"   :exit t)
  ("y" youtube-dl)
  ("C-y" youtube-dl)
  ("e" eshell)
  ("E" (eshell :new-buffer))
  ("s" shell)
  ("S" (let ((current-prefix-arg t)) (call-interactively #'shell)))
  ("a" (ansi-term "/bin/bash"))
  ("r" shell-command-in-subshell)
  ("t" (org-todo-list "NEW"))
  ("n" (org-todo-list "NEXT"))
  ("p" (org-todo-list "PROJ"))
  ("c" cleanup-old-buffers))


(defhydra hydras-navigation (global-map "C-x" :hint nil)
  "
_<left>_: prev buffer, _<right>_: next, _<up>_: pop mark, _<down>_: pop global mark
"
  ("<left>" previous-buffer)
  ("<right>" next-buffer)
  ("<up>" pop-to-mark-command)
  ("<down>" pop-global-mark)
  ("C-<left>" previous-buffer)
  ("C-<right>" next-buffer)
  ("C-<up>" pop-to-mark-command)
  ("C-<down>" pop-global-mark))

(provide 'hydras)
