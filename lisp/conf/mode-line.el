(setq sml/theme 'automatic)

(with-package (smart-mode-line)
  (sml/setup)
  ;; Optimization: Call `sml/generate-buffer-identification' only on
  ;; shell buffers, but not async command buffers.
  (remove-hook 'comint-output-filter-functions 'sml/generate-buffer-identification)
  (add-hook 'shell-after-cd-hook #'sml/generate-buffer-identification)
  (with-package-lazy (projectile)
    (setq projectile-mode-line nil)))

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
