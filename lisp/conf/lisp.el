(with-package-lazy (elisp-mode)
  (define-key emacs-lisp-mode-map (kbd "M-.") #'xref-find-definitions))

(when (fboundp 'global-eldoc-mode)
  (global-eldoc-mode 1))
