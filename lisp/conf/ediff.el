(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-grab-mouse nil)

(add-hook 'ediff-prepare-buffer-hook (lambda ()
                                       (visible-mode 1)
                                       (setq show-trailing-whitespace t)))

(add-hook 'ediff-cleanup-hook (lambda ()
                                (with-current-buffer ediff-buffer-A
                                  (visible-mode -1)
                                  (setq show-trailing-whitespace nil))
                                (with-current-buffer ediff-buffer-B
                                  (visible-mode -1)
                                  (setq show-trailing-whitespace nil))))


(provide 'conf/ediff)
