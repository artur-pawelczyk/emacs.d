(tool-bar-mode 0)

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)


(savehist-mode t)
(ido-mode 1)
(ido-everywhere 1)
(setq column-number-mode t)
(setq-default indent-tabs-mode nil)
(prefer-coding-system 'utf-8-unix)
(show-paren-mode)

(windmove-default-keybindings)

(setq calendar-week-start-day 1)
(setq async-shell-command-buffer 'new-buffer)

(global-set-key (kbd "C-w") 'kill-word-or-region)
(global-set-key (kbd "C-c C-k") 'kill-region)
(define-key key-translation-map (kbd "C-;") (kbd "C-SPC"))
(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key (kbd "<f5>") 'magit-status)
(global-set-key (kbd "M-z") 'zap-to-char-exclusive)

(provide 'conf/main)
