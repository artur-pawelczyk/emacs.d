(with-package-lazy (elisp-mode)
  (define-key emacs-lisp-mode-map (kbd "M-.") #'xref-find-definitions))

(when (fboundp 'global-eldoc-mode)
  (global-eldoc-mode 1))

(use-package company
  :commands company-mode
  :defer t
  :hook (emacs-lisp-mode . company-mode))

(use-package smartparens
  :commands smartparens-mode
  :defer t
  :hook (emacs-lisp-mode . smartparens-mode))
