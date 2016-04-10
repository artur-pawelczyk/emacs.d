(require 'dash)

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
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))

(with-package (undo-tree)
    (global-undo-tree-mode)
    (setq undo-tree-auto-save-history t)
    (setq undo-tree-history-directory-alist
      `((".*" . ,(expand-file-name "auto-save/" user-emacs-directory)))))

(defun maybe-enable-smartparens-mode ()
  (unless (eq major-mode 'java-mode)
    (smartparens-mode 1)))

(when (conf/installed-p 'smartparens)
  (add-hook 'prog-mode-hook #'maybe-enable-smartparens-mode)
  (add-hook 'ielm-mode-hook #'smartparens-mode))

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

(setq calendar-week-start-day 1)
(setq async-shell-command-buffer 'new-buffer)

;; Global keys
(global-set-key (kbd "C-w") #'kill-word-or-region)
(define-key key-translation-map (kbd "C-;") (kbd "C-SPC"))
(define-key key-translation-map (kbd "C-M-;") (kbd "C-M-SPC"))
(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key (kbd "<f5>") #'magit-status)
(global-set-key (kbd "<f6>") #'recompile)
(global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "M-SPC") #'cycle-spacing)
(global-set-key (kbd "C-x C-d") #'dired)
(global-set-key (kbd "M-o") #'other-window)
(global-set-key (kbd "C-c m") #'hydras-magit/body)
(global-set-key (kbd "C-x ^") #'hydra-resize-window/body)
(global-unset-key (kbd "C-z"))

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
(when (conf/installed-p 'ace-window)
  (global-set-key (kbd "M-o") #'ace-window)
  (setq aw-scope 'frame))
(with-package-lazy (ace-window)
  (require 'ace-window-relative nil :noerror))

;; easy-kill
(when (conf/installed-p 'easy-kill)
  (global-set-key (kbd "M-w") #'easy-kill)
  (global-set-key (kbd "C-M-SPC") #'easy-mark))

;; Linum-relative
(with-package-lazy (linum)
  (with-package (linum-relative)
    (linum-relative-toggle)))

;; Menubar
(when (conf/installed-p 'lacarte)
  (menu-bar-mode -1)
  (let ((menubar-function (if (conf/installed-p 'helm)
                              #'helm-browse-menubar
                            #'lacarte-execute-menu-command)))
    (global-set-key (kbd "<f10>") menubar-function)))

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

;; The silver searcher
(with-package-lazy (ag)
  (define-key ag-mode-map (kbd "n") #'next-error-no-select)
  (define-key ag-mode-map (kbd "p") #'previous-error-no-select))

;; Rename the shell buffers.
(defun conf/shell-boring-program? (name)
  (and (or (member name '("nohup"))
          (string-match-p "^[A-Z]+=.+$" name)) t))

(defun conf/shell-command-unique-name (command)
  (or (car (-drop-while (-partial #'conf/shell-boring-program?) (split-string command " ")))
      command))

(defun conf/shell-new-buffer-name (command)
  (let ((base-name (format "*%s: shell-command*" (conf/shell-command-unique-name command))))
    (generate-new-buffer-name base-name)))

(defun async-shell-command--set-buffer-name (orig-fun command &optional orig-buffer error-buffer)
  (let ((buffer-name (conf/shell-new-buffer-name command)))
    (if orig-buffer
        (apply orig-fun command orig-buffer error-buffer)
      (funcall orig-fun command buffer-name buffer-name))))

(advice-add 'shell-command :around #'async-shell-command--set-buffer-name)


(defvar linum-mode-suppress-update nil
  "If non-nil, prevents linum-mode from updating.  Meant to make
  resizing windows work faster.")

(defun linum-update-current--maybe-suppress (orig-fun &rest args)
  (unless linum-mode-suppress-update
    (apply orig-fun args)))

(advice-add #'linum-update-current :around #'linum-update-current--maybe-suppress)


(when (package-installed-p 'pdf-tools)
  (eval-after-load 'doc-view #'pdf-tools-install))
