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
(setq ido-enable-flex-matching t)
(when (require 'undo-tree nil 'noerror)
    (global-undo-tree-mode)
    (setq undo-tree-auto-save-history t))
(winner-mode t)
(windmove-default-keybindings)
(setq save-interprogram-paste-before-kill t)

(setq calendar-week-start-day 1)
(setq async-shell-command-buffer 'new-buffer)

(global-set-key (kbd "C-w") #'kill-word-or-region)
(define-key key-translation-map (kbd "C-;") (kbd "C-SPC"))
(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key (kbd "<f5>") #'magit-status)
(global-set-key (kbd "M-z") #'zap-to-char-exclusive)

;; Enable `view-mode' when showing function definition from help buffer.
(defun help-do-xref--enable-view-mode (&rest args)
  (when (eq (get major-mode 'derived-mode-parent) 'prog-mode)
    (view-mode 1)))
(advice-add 'help-do-xref :after #'help-do-xref--enable-view-mode)

;; Prefer spliting frame horizontally.
(setq split-height-threshold nil)
(setq split-width-threshold 300)

;; Ace-window
(with-package 'ace-window
  (global-set-key (kbd "M-o") #'ace-window)
  (setq aw-scope 'frame))


(provide 'conf/main)
