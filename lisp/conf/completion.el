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

(defun ido-move-dired-buffers-last ()
  (setq ido-temp-list (let* ((first (-filter (lambda (b) (not (dired-buffer? b))) ido-temp-list))
                             (last (-filter (lambda (b) (dired-buffer? b)) ido-temp-list)))
                        (append first last))))

(add-hook 'ido-make-buffer-list-hook #'ido-move-dired-buffers-last)

(provide 'conf/completion)
