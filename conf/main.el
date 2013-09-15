(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

(savehist-mode t)
(toggle-uniquify-buffer-names t)
(ido-mode 1)
(setq column-number-mode t)
(setq indent-tabs-mode nil)
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

(windmove-default-keybindings)

(setq w3m-enable-google-feeling-lucky nil)
(setq calendar-week-start-day 1)

(global-set-key (kbd "C-w") 'kill-word-or-region)
(global-set-key (kbd "C-c C-k") 'kill-region)
(global-set-key (kbd "C-;") 'set-mark-command)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(provide 'conf/main)
