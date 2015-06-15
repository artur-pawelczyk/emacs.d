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

(provide 'conf/completion)
