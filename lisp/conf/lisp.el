(add-hook 'emacs-lisp-mode-hook (lambda ()
                                  (local-set-key (kbd "M-.") 'find-function-at-point)))

(provide 'conf/lisp)
