(defun conf/enable-ido ()
  (require 'ido)
  (ido-mode 1)
  (ido-everywhere 1))

(defun conf/enable-helm ()
  (require 'helm)
  (helm-mode t)
  (helm-adaptive-mode t))

(defun conf/helm-setup-keys ()
  (require 'helm-config)
  (global-set-key (kbd "C-x b") 'helm-buffers-list)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files))

(defun conf/ido-helm-hybrid-setup ()
  "Use helm as main completion method and Ido for choosing
buffers and files."
  (interactive)
  (ido-mode) ;; Documentation of `helm-completing-read-handlers-alist'
             ;; claims that `ido-mode' does not need to be enabled,
             ;; although `ido-make-buffer-list-hook' is not applied
             ;; the mode is disabled.
  (add-to-list 'helm-completing-read-handlers-alist '(find-file . ido))
  (add-to-list 'helm-completing-read-handlers-alist '(find-file-other-window . ido))
  (add-to-list 'helm-completing-read-handlers-alist '(switch-to-buffer . ido))
  (global-set-key (kbd "C-x b") #'switch-to-buffer)
  (global-set-key (kbd "C-x C-f") #'find-file))

(eval-after-load "helm" #'conf/helm-setup-keys)

(if (require 'helm nil 'noerror)
    (conf/enable-helm)
  (conf/enable-ido))

(defvar conf/imenu-function (if (require 'helm nil 'noerror)
                                #'helm-imenu
                              #'imenu))

(defun conf/imenu ()
  (interactive)
  (call-interactively conf/imenu-function))

(with-package-lazy (auto-complete-mode)
  (require 'auto-complete-config)
  (ac-config-default))

(recentf-mode t)
(setq helm-ff-file-name-history-use-recentf t
      helm-buffers-fuzzy-matching t
      helm-split-window-in-side-p t)

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

(with-package-lazy (ido)
  (when (package-installed-p 'ido-vertical-mode)
    (setq ido-vertical-define-keys t)
     (ido-vertical-mode)))

(setq ido-case-fold t)
(setq ido-enable-regexp t)

(defun ido-move-dired-buffers-last ()
  (setq ido-temp-list (let* ((first (-filter (lambda (b) (not (dired-buffer? b))) ido-temp-list))
                             (last (-filter (lambda (b) (dired-buffer? b)) ido-temp-list)))
                        (append first last))))

(add-hook 'ido-make-buffer-list-hook #'ido-move-dired-buffers-last)

(defun conf/ido-keys ()
  (define-key ido-file-dir-completion-map (kbd "C-l") #'ido-up-directory))

(add-hook 'ido-setup-hook #'conf/ido-keys)

(provide 'conf/completion)
