(setq sml/theme 'respectful)

(defun conf/sml-setup-shell-buffer (fun &rest args)
  "Advice for `shell' function."
  (with-current-buffer (apply fun args)
    (add-hook 'comint-output-filter-functions 'sml/generate-buffer-identification nil :local)))

(with-package (smart-mode-line)
  (sml/setup)
  ;; Optimization: Call `sml/generate-buffer-identification' only on
  ;; shell buffers, but not async command buffers.
  (remove-hook 'comint-output-filter-functions 'sml/generate-buffer-identification)
  (advice-add 'shell :around #'conf/sml-setup-shell-buffer))

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
