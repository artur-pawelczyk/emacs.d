(setq sml/theme 'automatic)

(with-package (smart-mode-line)
  (sml/setup)
  ;; Optimization: Call `sml/generate-buffer-identification' only on
  ;; shell buffers, but not async command buffers.
  (remove-hook 'comint-output-filter-functions 'sml/generate-buffer-identification)
  (add-hook 'shell-after-cd-hook #'sml/generate-buffer-identification))

(setq rm-blacklist nil)
(let ((whitelist '(" View"
                   " Narrow"
                   " sWip"
                   " cider\\[.*\\]"
                   " Compiling"
                   " FlyC.*"
                   " Wrap"
                   " Vis")))
  (setq rm-whitelist (mapconcat 'identity whitelist "\\|")))

(with-package (projectile)
  (setq projectile-mode-line nil))
