(when (fboundp 'tool-bar-mode)
      (tool-bar-mode 0))
(when (fboundp 'scroll-bar-mode)
      (scroll-bar-mode 0))

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
(winner-mode t)
(windmove-default-keybindings)
(setq save-interprogram-paste-before-kill t)
(require 'linum-relative nil :noerror)

(with-package 'undo-tree
    (global-undo-tree-mode)
    (setq undo-tree-auto-save-history t))

(require 'hybrid-exp)
(with-package 'smartparens
  (define-key sp-keymap (kbd "C-M-f") #'sp-forward-sexp)
  (define-key sp-keymap (kbd "C-M-b") #'sp-backward-sexp)
  (define-key sp-keymap (kbd "C-M-u") #'sp-backward-up-sexp)
  (define-key sp-keymap (kbd "C-M-d") #'sp-down-sexp)
  (define-key sp-keymap (kbd "C-M-p") #'sp-backward-down-sexp)
  (define-key sp-keymap (kbd "C-M-n") #'sp-up-sexp)
  (define-key sp-keymap (kbd "C-M-k") #'conf/kill-sexp)
  (define-key sp-keymap (kbd "C-)") #'conf/forward-slurp)
  (define-key sp-keymap (kbd "C-}") #'sp-forward-barf-sexp)
  (define-key sp-keymap (kbd "C-(") #'sp-backward-slurp-sexp)
  (define-key sp-keymap (kbd "C-{") #'sp-backward-barf-sexp)
  (smartparens-global-mode 1))

(with-package 'highlight-symbol
  (add-hook 'prog-mode-hook #'highlight-symbol-nav-mode))


(setq calendar-week-start-day 1)
(setq async-shell-command-buffer 'new-buffer)

;; Global keys
(global-set-key (kbd "C-w") #'kill-word-or-region)
(define-key key-translation-map (kbd "C-;") (kbd "C-SPC"))
(define-key key-translation-map (kbd "C-M-;") (kbd "C-M-SPC"))
(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key (kbd "<f5>") #'magit-status)
(global-set-key (kbd "M-z") #'zap-to-char-exclusive)
(global-set-key (kbd "M-/") #'hippie-expand)


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

;; Expand-region
(with-package 'expand-region
  (global-set-key (kbd "C-M-SPC") #'er/expand-region))

(provide 'conf/main)
