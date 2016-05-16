(setq yas-prompt-functions  '(yas-completing-prompt))

;; Use only local snippets.  The variable is set always while loading the
;; package.  Must be overwritten after loading.
(with-package-lazy (yasnippet)
  (setq yas-snippet-dirs (list (user-file "snippets"))))
