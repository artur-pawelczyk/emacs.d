(setq dired-listing-switches "-hlDa")
(setq dired-dwim-target t)

(add-hook 'dired-load-hook
	  (lambda ()
	    (load "dired-x")))
(add-hook 'dired-mode-hook
	  (lambda ()
	    (setq dired-omit-files
		  (concat dired-omit-files "\\|^\\..+$"))))

(set 'video-player "smplayer")

(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "mupdf")
	("\\.avi\\'" video-player)
	("\\.flv\\'" video-player)
	("\\.webm\\'" video-player)
	("\\.mp4\\'" video-player)
	("\\.mov\\'" video-player)
	))

(provide 'conf/dired)
