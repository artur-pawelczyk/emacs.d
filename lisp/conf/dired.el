(with-package-lazy (dired)
  (require 'dired-x))

(setq dired-listing-switches "-hlDa")
(setq dired-dwim-target t)

(with-package-lazy (dired)
  (when (fboundp 'dired-hide-details-mode)
    (add-hook 'dired-mode-hook 'dired-hide-details-mode)
    (define-key dired-mode-map (kbd "C-x M-h") 'dired-hide-details-mode)))

(add-hook 'dired-mode-hook
	  (lambda ()
	    (setq dired-omit-files
		  (concat dired-omit-files "\\|^\\..+$"))))
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1)))

(defvar conf/video-player "smplayer")
(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" "mupdf")
	("\\.avi\\'" conf/video-player)
	("\\.flv\\'" conf/video-player)
	("\\.webm\\'" conf/video-player)
	("\\.mp4\\'" conf/video-player)
        ("\\.mp4.part\\'" conf/video-player)
	("\\.mov\\'" conf/video-player)
        ("\\.mkv\\'" conf/video-player)
	))

(provide 'conf/dired)
