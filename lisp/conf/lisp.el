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
  :init (require 'smartparens-config nil :noerror)
  :hook (emacs-lisp-mode . smartparens-mode)
  :bind (:map smartparens-mode-map
              ("C-M-f" . sp-forward-sexp)
              ("C-M-b" . sp-backward-sexp)
              ("C-M-u" . sp-backward-up-sexp)
              ("C-M-d" . sp-down-sexp)
              ("C-M-p" . sp-backward-down-sexp)
              ("C-M-n" . sp-up-sexp)
              ("C-M-k" . sp-kill-sexp)
              ("C-M-t" . sp-transpose-sexp)
              ("C-)" . sp-forward-slurp-sexp)
              ("C-}" . sp-forward-barf-sexp)
              ("C-(" . sp-backward-slurp-sexp)
              ("C-{" . sp-backward-barf-sexp)))
