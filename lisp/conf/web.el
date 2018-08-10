(when (conf/installed-p 'web-mode)
  (add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.vm\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.soy\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode))

  (setq web-mode-enable-auto-closing nil)
  (setq web-mode-enable-auto-opening nil)
  (setq web-mode-enable-auto-pairing nil)
  (setq web-mode-enable-auto-quoting nil))

(with-package-lazy (restclient)
  (add-hook 'restclient-response-loaded-hook #'view-mode))
