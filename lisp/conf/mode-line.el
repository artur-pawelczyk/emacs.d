(setq rm-blacklist nil)
(let ((whitelist '(" View"
                   " Narrow"
                   " sWip"
                   " cider\\[.*\\]"
                   " Compiling"
                   " FlyC.*"
                   " Wrap"
                   " Vis"
                   " Projectile\\[.*\\]")))
  (setq rm-whitelist (mapconcat 'identity whitelist "\\|")))


(with-package (rich-minority)
  (rich-minority-mode 1))
