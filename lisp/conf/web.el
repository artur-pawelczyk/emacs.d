(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))

(setq web-mode-enable-auto-closing nil)
(setq web-mode-enable-auto-opening nil)
(setq web-mode-enable-auto-pairing nil)
(setq web-mode-enable-auto-quoting nil)

(add-hook 'web-mode-hook #'subword-mode)

(provide 'conf/web)
