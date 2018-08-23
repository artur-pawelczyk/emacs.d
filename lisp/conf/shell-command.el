(require 'shell-command)

(setq async-shell-command-buffer 'new-buffer)

(global-set-key (kbd "M-!") #'background-shell-command)

(with-package-lazy (dired)
  (define-key dired-mode-map (kbd "!") #'background-dired-shell-command)
  (define-key dired-mode-map (kbd "M-!") #'background-shell-command))

(shell-command-rename-buffer-mode 1)
(shell-command-print-output-mode 1)


(defvar shell-after-cd-hook nil)

(defun conf/shell-directory-tracker--after (&rest ignore)
  (when shell-dirtrackp
    (run-hooks 'shell-after-cd-hook)))

(advice-add 'shell-directory-tracker :after #'conf/shell-directory-tracker--after)

(with-package-lazy (shell)
  (define-key shell-mode-map (kbd "C-c r") #'shell-command-rerun))
