(autoload 'emms "emms" nil :interactive)
(autoload 'emms-info-metaflac "emms-info-metaflac")

(with-package-lazy (emms)
  (emms-all)
  (emms-mode-line -1)
  (setq emms-player-list '(emms-player-mplayer))
  (setq emms-source-file-default-directory "~/Music/")
  (setq emms-info-functions (append emms-info-functions '(emms-info-metaflac)))
  (setq emms-playlist-buffer-name "*EMMS Playlist*"))

(defvar conf/add-to-playlist-function (lambda (&rest args) (message "No music player installed")))
(when (package-installed-p 'emms)
  (setq conf/add-to-playlist-function #'emms-add-file))

(defun emms-add-dired-and-show ()
  (interactive)
  (emms-add-dired)
  (emms))

(with-package-lazy (dired)
  (define-key dired-mode-map "E" #'emms-add-dired-and-show))

(with-package-lazy (emms-playlist-mode)
  (define-key emms-playlist-mode-map (kbd "-") #'emms-volume-lower)
  (define-key emms-playlist-mode-map (kbd "=") #'emms-volume-raise)
  (define-key emms-playlist-mode-map (kbd "+") #'emms-volume-raise))

(provide 'conf/emms)
