(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

(savehist-mode t)
(toggle-uniquify-buffer-names t)
(ido-mode 1)
(defalias 'list-buffer 'ibuffer)
(setq column-number-mode t)
(setq indent-tabs-mode nil)

(windmove-default-keybindings)

(setq w3m-enable-google-feeling-lucky nil)
(setq calendar-week-start-day 1)

(global-set-key (kbd "C-w") 'kill-word-or-region)
(global-set-key (kbd "C-c C-k") 'kill-region)
(global-set-key (kbd "C-;") 'set-mark-command)

(provide 'conf/main)
