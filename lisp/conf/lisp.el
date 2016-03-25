(add-hook 'emacs-lisp-mode-hook (lambda ()
                                  (local-set-key (kbd "M-.") #'find-function-at-point)))

(when (fboundp 'global-eldoc-mode)
  (global-eldoc-mode 1))
