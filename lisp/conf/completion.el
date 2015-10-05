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

(defun conf/enable-helm ()
  (interactive)
  (require 'helm)
  (require 'helm-config)
  (helm-mode 1)
  (helm-adaptive-mode 1)
  (global-set-key (kbd "C-x b") 'helm-buffers-list)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files))

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

(defun conf/disable-helm ()
  (interactive)
  (helm-mode -1)
  (conf/completion-default-keys))

(defun conf/ido-helm-hybrid-setup ()
  "Use helm as main completion method and Ido for choosing
buffers and files."
  (interactive)
  (conf/enable-helm)
  (ido-mode) ;; Documentation of `helm-completing-read-handlers-alist'
             ;; claims that `ido-mode' does not need to be enabled,
             ;; although `ido-make-buffer-list-hook' is not applied
             ;; when the mode is disabled.
  (add-to-list 'helm-completing-read-handlers-alist '(find-file . ido))
  (add-to-list 'helm-completing-read-handlers-alist '(find-file-other-window . ido))
  (add-to-list 'helm-completing-read-handlers-alist '(switch-to-buffer . ido))
  (global-set-key (kbd "C-x b") #'switch-to-buffer)
  (global-set-key (kbd "C-x C-f") #'find-file))

(after-init
    (cond
     ((require 'ivy nil :noerror)
      (ivy-mode 1)
      (conf/enable-ido))
     ((require 'helm nil :noerror)
      (conf/ido-helm-hybrid-setup))
     (t (conf/enable-ido))))


;; helm-imenu
(defvar conf/imenu-function (if (package-installed-p 'helm)
                                #'helm-imenu
                              #'imenu))

(defun conf/imenu ()
  (interactive)
  (call-interactively conf/imenu-function))


;; Helm configuration
(setq helm-ff-file-name-history-use-recentf t
      helm-buffers-fuzzy-matching t
      helm-split-window-in-side-p t
      helm-ag-base-command "ag --nocolor --nogroup --ignore-case")

;; Customizing `helm-command-prefix-key' triggers come code that would
;; not run if set by `setq'.
(custom-set-variables '(helm-command-prefix-key "C-c h"))

(with-package-lazy (helm)
  (define-key helm-map (kbd "C-w") #'kill-word-or-region)
  (define-key helm-map (kbd "<f1>") nil)
  (define-key helm-map (kbd "<f2>") nil)
  (define-key helm-map (kbd "<f3>") nil)
  (define-key helm-map (kbd "<f4>") nil)
  (define-key helm-map (kbd "<f5>") nil)
  (define-key helm-map (kbd "<f6>") nil)
  (define-key helm-map (kbd "<f7>") nil)
  (define-key helm-map (kbd "<f8>") nil)
  (define-key helm-map (kbd "<f9>") nil)
  (define-key helm-map (kbd "<f10>") nil)
  (define-key helm-map (kbd "<f11>") nil)
  (define-key helm-map (kbd "<f12>") nil))


;; Ido
(with-package-lazy (ido)
  (when (package-installed-p 'ido-vertical-mode)
    (setq ido-vertical-define-keys t)
     (ido-vertical-mode)))

(setq ido-case-fold t)
(setq ido-enable-regexp t)
(setq ido-default-buffer-method 'selected-window) 

(defun ido-move-dired-buffers-last ()
  (setq ido-temp-list (let* ((first (-filter (lambda (b) (not (dired-buffer? b))) ido-temp-list))
                             (last (-filter (lambda (b) (dired-buffer? b)) ido-temp-list)))
                        (append first last))))

(add-hook 'ido-make-buffer-list-hook #'ido-move-dired-buffers-last)

(defun conf/ido-keys ()
  (define-key ido-file-dir-completion-map (kbd "C-l") #'ido-up-directory))

(add-hook 'ido-setup-hook #'conf/ido-keys)

(defun ido-add-dot-file ()
  (setq ido-temp-list (cons "." ido-temp-list)))

(add-hook 'ido-make-file-list-hook #'ido-add-dot-file)


;; Auto-complete is currenty used only for Jedi
(with-package-lazy (auto-complete-mode)
  (require 'auto-complete-config)
  (ac-config-default))


(recentf-mode t)

(provide 'conf/completion)
