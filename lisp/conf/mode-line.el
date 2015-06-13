(setq sml/theme 'respectful)
(with-package (smart-mode-line)
  (add-hook 'after-init-hook #'sml/setup))

(setq rm-blacklist '(" MRev" " Helm" " AC" " Undo-Tree" " Abbrev" " SP" " SP/s" " yas" " GG"))

(with-package (projectile)
  (setq projectile-mode-line nil))

(provide 'conf/mode-line)
