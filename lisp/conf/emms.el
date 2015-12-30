(with-package (emms-setup emms-info-metaflac)
  (emms-all)
  (emms-mode-line -1)
  (setq emms-player-list '(emms-player-mplayer))
  (setq emms-source-file-default-directory "~/Music/")
  (setq emms-info-functions (append emms-info-functions '(emms-info-metaflac)))
  (setq emms-playlist-buffer-name "*EMMS Playlist*"))

(defvar conf/add-to-playlist-function (lambda (&rest args) (message "No music player installed")))

(with-package (emms)
  (setq conf/add-to-playlist-function #'emms-add-file))

(defvar conf/music-file-extensions '("flac" "ogg" "mp3"))

(defun conf/find-file-noselect--audio-file (orig-fun &rest args)
  (if (and (member (file-name-extension (car args)) conf/music-file-extensions)
           (y-or-n-p (format "File %s looks like an audio file, add to the current playlist? "
                             (car args))))
      (funcall conf/add-to-playlist-function (car args))
    (apply orig-fun args)))

(with-package (emms)
  (advice-add #'find-file-noselect :around #'conf/find-file-noselect--audio-file))

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
