(setq lsp-rust-analyzer-server-command (concat (getenv "HOME") "/.cargo/bin/rust-analyzer"))
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rustic-mode))
