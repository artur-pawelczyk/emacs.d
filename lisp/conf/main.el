(require 'dash)

(when (fboundp 'tool-bar-mode)
      (tool-bar-mode 0))
(when (fboundp 'scroll-bar-mode)
      (scroll-bar-mode 0))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'erase-buffer 'disabled nil)

(savehist-mode t)
(setq column-number-mode t)
(setq-default indent-tabs-mode nil)
(prefer-coding-system 'utf-8-unix)
(show-paren-mode)
(setq ido-enable-flex-matching t)
(setq save-interprogram-paste-before-kill t)
(fset 'yes-or-no-p #'y-or-n-p)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(setq enable-recursive-minibuffers t)
(blink-cursor-mode 1)
(setq calendar-week-start-day 1)
(read-y-or-n-mode 1)
(umessage-mode 1)
(setq sentence-end-double-space nil)
(setq ring-bell-function #'ignore)
(add-to-list 'auto-mode-alist '("\\password-store/.*\\.gpg\\'" . pass-view-mode))

(with-package (undo-tree)
    (setq undo-tree-auto-save-history t)
    (setq undo-tree-history-directory-alist
      `((".*" . ,(expand-file-name "auto-save/" user-emacs-directory)))))

(defun maybe-enable-smartparens-mode ()
  (unless (member major-mode '(java-mode js2-mode))
    (smartparens-mode 1)))

(when (conf/installed-p 'smartparens)
  (add-hook 'prog-mode-hook #'maybe-enable-smartparens-mode)
  (add-hook 'ielm-mode-hook #'smartparens-mode)
  (add-hook 'nxml-mode-hook #'smartparens-mode)
  (add-hook 'nxml-mode-hook #'show-smartparens-mode))

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
(global-set-key (kbd "C-x 5 0") #'delete-frame-if-only)
(global-set-key (kbd "C-x n n") #'narrow-or-widen-dwim)
(global-set-key (kbd "C-c r") #'revert-buffer)
(global-set-key (kbd "C-x 6") #'previous-buffer)
(global-set-key (kbd "C-x 7") #'next-buffer)

(global-set-key (kbd "C-x 4 c") #'clone-indirect-buffer-in-place)
(global-set-key (kbd "C-x 4 C") #'clone-indirect-buffer-other-window)
(global-unset-key (kbd "C-z"))

(when (conf/installed-p 'hydra)
  (global-set-key (kbd "C-x ]") #'hydras-forward-page)
  (global-set-key (kbd "C-x [") #'hydras-backward-page)
  (global-set-key (kbd "C-c C-h") #'hydras-home/body)
  (global-set-key (kbd "C-c DEL") #'hydras-home/body)
  (global-set-key (kbd "C-c h") #'hydras-home/body))

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
(menu-bar-mode -1)

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
  (cl-assert (< emacs-major-version 25) :show-args "Use `G M-n' instead")
  (if (eq major-mode 'eww-mode)
      (eww (read-from-minibuffer "Url: " eww-current-url))
    (user-error "Not in an eww buffer")))

(with-package-lazy (eww)
  (unless (lookup-key eww-mode-map (kbd "o"))
    (define-key eww-mode-map (kbd "o") #'eww))
  (unless (lookup-key eww-mode-map (kbd "O"))
    (define-key eww-mode-map (kbd "O") #'eww-open-relative)))

;; Auto save
(setq backup-directory-alist
      `(("." . ,(expand-file-name "auto-save/" user-emacs-directory))))

(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))

;; The silver searcher
(with-package-lazy (ag)
  (define-key ag-mode-map (kbd "n") #'next-error-no-select)
  (define-key ag-mode-map (kbd "p") #'previous-error-no-select))


(defvar linum-mode-suppress-update nil
  "If non-nil, prevents linum-mode from updating.  Meant to make
  resizing windows work faster.")

(defun linum-update-current--maybe-suppress (orig-fun &rest args)
  (unless linum-mode-suppress-update
    (apply orig-fun args)))

(advice-add #'linum-update-current :around #'linum-update-current--maybe-suppress)


(when (package-installed-p 'pdf-tools)
  (eval-after-load 'doc-view #'pdf-tools-install))


(when (conf/installed-p 'flycheck)
  (global-set-key (kbd "C-c !") #'flycheck-mode))

(with-package-lazy (flycheck)
  (require 'flycheck-java nil :noerror))


;; Ask before running `save-buffers-kill-terminal'
(advice-add 'save-buffers-kill-terminal :around #'ask-advice)


;; `save-place-mode' function was introduced in Emacs 25.
(require 'saveplace nil :noerror)
(if (fboundp 'save-place-mode)
    (save-place-mode 1)
  (setq-default save-place t))


;; enable coloring in compilation buffers
(defun conf/colorize-compilation ()
  "Colorize from `compilation-filter-start' to `point'."
  (require 'ansi-color)
  (unless (eq major-mode 'ag-mode)
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region
       compilation-filter-start (point)))))

(add-hook 'compilation-filter-hook
          #'conf/colorize-compilation)

(with-package-lazy (elfeed-show)
  (define-key elfeed-show-mode-map (kbd "TAB") #'shr-next-link))

(with-package (avy)
  (global-set-key (kbd "M-g c") #'avy-goto-char-timer)
  (global-set-key (kbd "M-g M-c") #'avy-goto-char-timer)
  (global-set-key (kbd "M-g M-g") #'avy-goto-line))

(with-package-lazy (frame)
  (setq default-frame-alist (cons '(fullscreen . maximized) default-frame-alist)))
