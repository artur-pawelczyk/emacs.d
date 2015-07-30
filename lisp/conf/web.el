(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))

(setq web-mode-enable-auto-closing nil)

(add-hook 'web-mode-hook #'subword-mode)

(provide 'conf/web)
