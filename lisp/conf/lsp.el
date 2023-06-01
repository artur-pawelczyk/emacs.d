(with-package-lazy (lsp-mode)
  (define-key lsp-mode-map (kbd "C-c M-.") #'lsp-find-implementation)
  (define-key lsp-mode-map (kbd "C-c C-c") lsp-command-map))
