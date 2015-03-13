(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook (lambda ()
                           (subword-mode)))
                                     
(eval-after-load "js2-mode" '(define-key js2-mode-map (kbd "M-.") (lambda () (funcall conf/imenu-function))))

(provide 'conf/javascript)
