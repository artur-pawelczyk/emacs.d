(require 'dash)
(require 'dash-functional)

(defun conf/enable-ido ()
  (interactive)
  (require 'ido)
  (ido-mode 1)
  (ido-everywhere 1)
  (global-set-key (kbd "C-x b") #'ido-switch-buffer)
  (global-set-key (kbd "C-x 4 b") #'ido-switch-buffer-other-window)
  (global-set-key (kbd "C-x 5 b") #'ido-switch-buffer-other-frame)
  (global-set-key (kbd "C-x C-f") #'ido-find-file)
  (global-set-key (kbd "C-x 4 C-f") #'ido-find-file-other-window)
  (global-set-key (kbd "C-x C-4 C-f") #'ido-find-file-other-window))


(defun conf/completion-default-keys ()
  (global-set-key (kbd "M-x") #'execute-extended-command)
  (global-set-key (kbd "C-x b") #'switch-to-buffer)
  (global-set-key (kbd "C-x 4 b") #'switch-to-buffer-other-window)
  (global-set-key (kbd "C-x 5 b") #'switch-to-buffer-other-frame)
  (global-set-key (kbd "C-x C-f") #'find-file)
  (global-set-key (kbd "C-x 4 C-f") #'find-file-other-window)
  (global-set-key (kbd "C-x C-4 C-f") #'find-file-other-window))

(defun conf/disable-ido ()
  (interactive)
  (ido-mode -1)
  (conf/completion-default-keys))

(defun conf/enable-counsel ()
  (interactive)
  (require 'counsel)
  (global-set-key (kbd "C-x b") #'counsel-switch-buffer)
  (global-set-key (kbd "C-x 4 b") #'counsel-switch-buffer-other-window)
  (global-set-key (kbd "C-x C-f") #'counsel-find-file))


(defun conf/imenu ()
  (interactive)
  (call-interactively conf/imenu-function))


;; Ido
(with-package-lazy (ido)
  (when (conf/installed-p 'ido-vertical-mode)
    (setq ido-vertical-define-keys t)
     (ido-vertical-mode)))

(setq ido-case-fold t)
(setq ido-enable-regexp t)
(setq ido-default-buffer-method 'selected-window)
(setq ido-default-file-method 'selected-window)
(setq ido-use-virtual-buffers t)

(defun ido-move-dired-buffers-last ()
  (let ((omit-first? (eq this-command 'ido-kill-buffer)))
    (setq ido-temp-list (if omit-first?
                            (cons (car ido-temp-list) (conf/ido-sort-buffers (cdr ido-temp-list)))
                          (conf/ido-sort-buffers ido-temp-list)))))

(defun conf/ido-sort-buffers (buffers)
  (let ((first (-filter (-not #'dired-buffer?) ido-temp-list))
        (last (-filter #'dired-buffer? ido-temp-list)))
    (append first last)))

(defun ido-toggle-dired-buffers ()
  (interactive)
  (if (member 'ido-move-dired-buffers-last ido-make-buffer-list-hook)
      (remove-hook 'ido-make-buffer-list-hook 'ido-move-dired-buffers-last)
    (add-hook 'ido-make-buffer-list-hook 'ido-move-dired-buffers-last))
  (setq ido-text-init ido-text)
  (setq ido-exit 'refresh)
  (exit-minibuffer))

(defun conf/ido-keys ()
  (define-key ido-file-dir-completion-map (kbd "C-l") #'ido-up-directory)
  (define-key ido-buffer-completion-map (kbd "C-v") #'ido-toggle-dired-buffers))

(with-package-lazy (ido)
  (add-hook 'ido-setup-hook #'conf/ido-keys)
  (add-hook 'ido-make-file-list-hook #'ido-add-dot-file))

(defun ido-add-dot-file ()
  (setq ido-temp-list (cons "." ido-temp-list)))


(defun ido-insert-wildcard ()
  (interactive)
  (insert ".*"))

(with-package-lazy (ido)
  (add-hook 'ido-setup-hook (lambda ()
                              (define-key ido-completion-map (kbd "SPC") #'ido-insert-wildcard))))



;; Ivy
(with-package (ivy)
  (ivy-mode 1))

(with-package-lazy (ivy)
  (setq ivy-initial-inputs-alist
        (-filter (-not (-compose (-partial #'equal "^") #'cdr))
                 ivy-initial-inputs-alist)))

(defvar conf/ivy-completing-read-omit-list
  '(ido-edit-input ido-magic-forward-char find-file))

(defun conf/ivy-completing-read--omit (orig &rest args)
  "Advice around `ivy-completing-read'.  Use the default
completing method of Emacs when `completing-read' has been
invoked by functions specified by `conf/ivy-completing-read-omit-list'"
  (if (memq this-command conf/ivy-completing-read-omit-list)
      (apply #'completing-read-default args)
    (apply orig args)))

(with-package-lazy (ivy)
  (advice-add 'ivy-completing-read :around #'conf/ivy-completing-read--omit))

(if (conf/installed-p 'counsel)
    (conf/enable-counsel))


;; M-x
(defvar conf/extended-command-function (if (conf/installed-p 'counsel)
                                           #'counsel-M-x
                                         #'execute-extended-command))

(defun conf/extended-command ()
  "Run the simple `execute-extended-command' while defining a
keyboard macro.  Otherwise use function defined by `conf/extended-command-function'"
  (interactive)
  (if (or defining-kbd-macro executing-kbd-macro)
      (let ((completing-read-function #'completing-read-default))
        (call-interactively #'execute-extended-command))
    (call-interactively conf/extended-command-function)))

(global-set-key (kbd "M-x") #'conf/extended-command)

(with-package-lazy (counsel)
  (ivy-configure 'counsel-M-x
    :initial-input ""))


(recentf-mode t)


