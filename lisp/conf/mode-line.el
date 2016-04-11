(setq sml/theme 'respectful)
(with-package (smart-mode-line)
  (sml/setup))

(setq rm-blacklist nil)
(let ((whitelist '(" View"
                   " Narrow"
                   " sWip"
                   " cider\\[.*\\]"
                   " Compiling"
                   " FlyC.*"
                   " Wrap")))
  (setq rm-whitelist (mapconcat 'identity whitelist "\\|")))

(with-package (projectile)
  (setq projectile-mode-line nil))
