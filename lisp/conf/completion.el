(defun conf/enable-ido ()
  (require 'ido)
  (ido-mode 1)
  (ido-everywhere 1))

(defun conf/helm-setup-keys ()
  (global-set-key (kbd "C-x b") 'helm-buffers-list)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files))

(eval-after-load "helm" #'conf/helm-setup-keys)

(if (require 'helm nil 'noerror)
    (helm-mode t)
  (conf/enable-ido))

(defvar conf/imenu-function (if (require 'helm nil 'noerror)
                                #'helm-imenu
                              #'imenu))

(eval-after-load "auto-complete-config" #'ac-config-default)
(require 'auto-complete-config nil 'noerror)

(provide 'conf/completion)
