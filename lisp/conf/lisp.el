(add-hook 'emacs-lisp-mode-hook (lambda ()
                                  (local-set-key (kbd "M-.") #'find-function-at-point)))

(global-eldoc-mode 1)

(provide 'conf/lisp)
