(tool-bar-mode 0)
(scroll-bar-mode 0)

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)


(savehist-mode t)
(setq column-number-mode t)
(setq-default indent-tabs-mode nil)
(prefer-coding-system 'utf-8-unix)
(show-paren-mode)
(if (require 'undo-tree nil 'noerror)
    (global-undo-tree-mode))

(windmove-default-keybindings)

(setq calendar-week-start-day 1)
(setq async-shell-command-buffer 'new-buffer)

(global-set-key (kbd "C-w") #'kill-word-or-region)
(global-set-key (kbd "C-c C-k") #'kill-region)
(define-key key-translation-map (kbd "C-;") (kbd "C-SPC"))
(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key (kbd "<f5>") #'magit-status)
(global-set-key (kbd "M-z") #'zap-to-char-exclusive)

;; Enable view-mode when showing function definition from help buffer.
(defun help-do-xref--enable-view-mode (&rest args)
  (view-mode 1))
(advice-add 'help-do-xref :after #'help-do-xref--enable-view-mode)

;; Prefer spliting frame horizontally.
(setq split-height-threshold nil)
(setq split-width-threshold 300)

(provide 'conf/main)
