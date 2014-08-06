(add-hook 'dired-load-hook
	  (lambda ()
	    (load "dired-x")))

(require 'dired)

(setq dired-listing-switches "-hlDa")
(setq dired-dwim-target t)

(when (fboundp 'dired-hide-details-mode)
    (add-hook 'dired-mode-hook 'dired-hide-details-mode)
    (define-key dired-mode-map (kbd "C-x M-h") 'dired-hide-details-mode))

(add-hook 'dired-mode-hook
	  (lambda ()
	    (setq dired-omit-files
		  (concat dired-omit-files "\\|^\\..+$"))))
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

(set 'video-player "smplayer")
(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "mupdf")
	("\\.avi\\'" video-player)
	("\\.flv\\'" video-player)
	("\\.webm\\'" video-player)
	("\\.mp4\\'" video-player)
	("\\.mov\\'" video-player)
        ("\\.mkv\\'" video-player)
	))

(provide 'conf/dired)
