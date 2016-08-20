(require 'shell-command)

(setq async-shell-command-buffer 'new-buffer)

(global-set-key (kbd "M-!") #'background-shell-command)

(with-package-lazy (dired)
  (define-key dired-mode-map (kbd "!") #'background-dired-shell-command)
  (define-key dired-mode-map (kbd "M-!") #'background-shell-command))

(shell-command-rename-buffer-mode 1)
(shell-command-print-output-mode 1)
