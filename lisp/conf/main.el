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
(setq save-interprogram-paste-before-kill t)
(fset 'yes-or-no-p #'y-or-n-p)

(with-package (undo-tree)
    (global-undo-tree-mode)
    (setq undo-tree-auto-save-history t)
    (setq undo-tree-history-directory-alist
      `((".*" . ,(expand-file-name "auto-save/" user-emacs-directory)))))

(when (package-installed-p 'smartparens)
  (add-hook 'prog-mode-hook #'smartparens-mode))

(require 'hybrid-exp)
(with-package-lazy (smartparens)
  (define-key smartparens-mode-map (kbd "C-M-f") #'sp-forward-sexp)
  (define-key smartparens-mode-map (kbd "C-M-b") #'sp-backward-sexp)
  (define-key smartparens-mode-map (kbd "C-M-u") #'sp-backward-up-sexp)
  (define-key smartparens-mode-map (kbd "C-M-d") #'sp-down-sexp)
  (define-key smartparens-mode-map (kbd "C-M-p") #'sp-backward-down-sexp)
  (define-key smartparens-mode-map (kbd "C-M-n") #'sp-up-sexp)
  (define-key smartparens-mode-map (kbd "C-M-k") #'conf/kill-sexp)
  (define-key smartparens-mode-map (kbd "C-)") #'conf/forward-slurp)
  (define-key smartparens-mode-map (kbd "C-}") #'sp-forward-barf-sexp)
  (define-key smartparens-mode-map (kbd "C-(") #'sp-backward-slurp-sexp)
  (define-key smartparens-mode-map (kbd "C-{") #'sp-backward-barf-sexp)
  (require 'smartparens-config nil :noerror))

(with-package (highlight-symbol)
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
(global-set-key (kbd "M-SPC") #'cycle-spacing)
(global-set-key (kbd "C-x C-d") #'dired)
(global-set-key (kbd "M-o") #'other-window)

;; This key binding gets overwritten by some package if set here.  Set
;; it after init.
(add-hook 'after-init-hook (lambda ()
                             (global-set-key (kbd "C-x c") #'calendar)))

;; Enable `view-mode' when showing function definition from help buffer.
(defun help-do-xref--enable-view-mode (&rest args)
  (when (eq (get major-mode 'derived-mode-parent) 'prog-mode)
    (view-mode 1)))
(advice-add 'help-do-xref :after #'help-do-xref--enable-view-mode)

;; Prefer spliting frame horizontally.
(setq split-height-threshold nil)
(setq split-width-threshold 300)

;; Ace-window
(when (package-installed-p 'ace-window)
  (global-set-key (kbd "M-o") #'ace-window)
  (setq aw-scope 'frame))
(with-package-lazy (ace-window)
  (require 'ace-window-relative nil :noerror))

;; Expand-region
(when (package-installed-p 'expand-region)
  (global-set-key (kbd "C-M-SPC") #'er/expand-region))

;; Linum-relative
(with-package-lazy (linum)
  (with-package (linum-relative)
    (linum-relative-toggle)))

;; Helm swoop
(when (package-installed-p 'helm-swoop)
  ;; Bind in place of `isearch-forward-regexp'.  Use `C-u C-s' to
  ;; toggle regexp isearch.
  (global-set-key (kbd "C-M-s") #'helm-swoop))

;; Helm menubar
(when (package-installed-p 'lacarte)
  (menu-bar-mode -1)
  (global-set-key (kbd "<f10>") #'helm-browse-menubar))

;; Winner mode
(winner-mode t)
(global-set-key (kbd "C-x ,") #'winner-undo)
(global-set-key (kbd "C-x .") #'winner-redo)

;; Calc

(with-package-lazy (calc-mode)
  (calc-group-char (aref " " 0)))

;; EWW
(defun eww-open-relative ()
  (interactive)
  (if (eq major-mode 'eww-mode)
      (eww (read-from-minibuffer "Url: " eww-current-url))
    (user-error "Not in an eww buffer")))

(with-package-lazy (eww)
  (define-key eww-mode-map (kbd "o") #'eww)
  (define-key eww-mode-map (kbd "O") #'eww-open-relative))

;; Auto save
(setq backup-directory-alist
      `(("." . ,(expand-file-name "auto-save/" user-emacs-directory))))

(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))

(provide 'conf/main)
