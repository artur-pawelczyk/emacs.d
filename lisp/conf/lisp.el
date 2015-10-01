(add-hook 'emacs-lisp-mode-hook (lambda ()
                                  (local-set-key (kbd "M-.") #'find-function-at-point)))

(add-hook 'emacs-lisp-mode-hook #'eldoc-mode)

(provide 'conf/lisp)
