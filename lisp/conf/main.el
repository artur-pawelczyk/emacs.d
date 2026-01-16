(require 'dash)
(require 'use-package)
(require 'bind-key)

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
(show-paren-mode 1)
(setq show-paren-context-when-offscreen 'child-frame)
(setq ido-enable-flex-matching t)
(setq save-interprogram-paste-before-kill t)
(setq enable-recursive-minibuffers t)
(blink-cursor-mode 1)
(setq calendar-week-start-day 1)
(umessage-mode 1)
(setq sentence-end-double-space nil)
(setq ring-bell-function #'ignore)
(add-to-list 'auto-mode-alist '("\\password-store/.*\\.gpg\\'" . pass-view-mode))
(setq use-short-answers t)
(setq scroll-margin 3)
(pixel-scroll-precision-mode 1)
(setq frame-resize-pixelwise t)
(repeat-mode 1)

(when (conf/installed-p 'smartparens)
  (add-hook 'ielm-mode-hook #'smartparens-mode)
  (add-hook 'nxml-mode-hook #'smartparens-mode)
  (add-hook 'nxml-mode-hook #'show-smartparens-mode))

;; Global keys
(global-set-key (kbd "C-w") #'kill-word-or-region)
(define-key key-translation-map [?\C-h] [?\C-?])
(define-key key-translation-map (kbd "C-;") (kbd "C-SPC"))
(define-key key-translation-map (kbd "C-M-;") (kbd "C-M-SPC"))
(global-set-key (kbd "<f5>") #'magit-status)
(global-set-key (kbd "<f6>") #'recompile)
(global-set-key (kbd "M-/") #'hippie-expand)
(global-set-key (kbd "M-SPC") #'cycle-spacing)
(global-set-key (kbd "M-o") #'other-window)
(global-set-key (kbd "C-x 5 0") #'delete-frame-if-only)
(global-set-key (kbd "C-x n n") #'narrow-or-widen-dwim)
(global-set-key (kbd "C-c r") #'revert-buffer)
(global-set-key (kbd "C-x 6") #'previous-buffer)
(global-set-key (kbd "C-x 7") #'next-buffer)

(global-set-key (kbd "C-x 4 c") #'clone-indirect-buffer-in-place)
(global-set-key (kbd "C-x 4 C") #'clone-indirect-buffer-other-window)
(global-unset-key (kbd "C-z"))

(with-package (smartparens)
  (define-key smartparens-mode-map (kbd "C-M-f") #'sp-forward-sexp)
  (define-key smartparens-mode-map (kbd "C-M-b") #'sp-backward-sexp)
  (define-key smartparens-mode-map (kbd "C-M-u") #'sp-backward-up-sexp)
  (define-key smartparens-mode-map (kbd "C-M-d") #'sp-down-sexp)
  (define-key smartparens-mode-map (kbd "C-M-p") #'sp-backward-down-sexp)
  (define-key smartparens-mode-map (kbd "C-M-n") #'sp-up-sexp)
  (define-key smartparens-mode-map (kbd "C-M-k") #'sp-kill-sexp)
  (define-key smartparens-mode-map (kbd "C-M-t") #'sp-transpose-sexp)
  (define-key smartparens-mode-map (kbd "C-)") #'sp-forward-slurp-sexp)
  (define-key smartparens-mode-map (kbd "C-}") #'sp-forward-barf-sexp)
  (define-key smartparens-mode-map (kbd "C-(") #'sp-backward-slurp-sexp)
  (define-key smartparens-mode-map (kbd "C-{") #'sp-backward-barf-sexp)
  (require 'smartparens-config nil :noerror))

(when (conf/installed-p 'hydra)
  (require 'hydras)
  (require 'hydra-resize-window))

;; This key binding gets overwritten by some package if set here.  Set
;; it after init.
(add-hook 'after-init-hook (lambda ()
                             (global-set-key (kbd "C-x c") #'calendar)))

;; Ace-window
;; (use-package ace-window
;;   :init
;;   (setq aw-scope 'frame)
;;   (require 'ace-window-relative nil :noerror)
;;   (bind-key* "M-o" 'ace-window))

(if (conf/installed-p 'hydra)
    (bind-key* "M-o" #'hydra-switch-window)
  (bind-key* "M-o" #'other-window))

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
(global-set-key (kbd "C-x ,") #'winner-undo) ;; will be overriden by hydra
(global-set-key (kbd "C-x .") #'winner-redo)
(global-set-key (kbd "C-x C-,") #'winner-undo)
(global-set-key (kbd "C-x C-.") #'winner-redo)

;; Calc
(with-package-lazy (calc-mode)
  (calc-group-char (aref " " 0)))
(setq calc-kill-line-numbering nil)


(when (conf/installed-p 'flycheck)
  (global-set-key (kbd "C-c !") #'flycheck-mode))


;; Ask before running `save-buffers-kill-terminal'
(advice-add 'save-buffers-kill-terminal :around #'ask-advice)


;; enable coloring in compilation buffers
;; TODO See if this is still needed
(defun conf/colorize-compilation ()
  "Colorize from `compilation-filter-start' to `point'."
  (require 'ansi-color)
  (unless (eq major-mode 'ag-mode)
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region
       compilation-filter-start (point)))))

(add-hook 'compilation-filter-hook
          #'conf/colorize-compilation)

(with-package (avy)
  (global-set-key (kbd "M-g c") #'avy-goto-char-timer)
  (global-set-key (kbd "M-g M-c") #'avy-goto-char-timer)
  (global-set-key (kbd "M-g M-g") #'avy-goto-line))

(with-package-lazy (frame)
  (setq default-frame-alist (cons '(fullscreen . maximized) default-frame-alist)))
