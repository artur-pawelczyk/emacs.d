(setq sml/theme 'respectful)
(with-package (smart-mode-line)
  (sml/setup))

(setq rm-blacklist nil)
(setq rm-whitelist (mapconcat 'identity '(" View" " Narrow" " sWip" " cider\\[.*\\]" " Compiling" " FlyC.*") "\\|"))

(with-package (projectile)
  (setq projectile-mode-line nil))

(provide 'conf/mode-line)
