(with-package (emms-setup emms-info-metaflac)
  (emms-all)
  (emms-mode-line -1)
  (setq emms-player-list '(emms-player-mpg321 emms-player-ogg123 emms-player-mplayer-playlist emms-player-mplayer emms-player-vlc))
  (setq emms-source-file-default-directory "~/Music/")
  (setq emms-info-functions (append emms-info-functions '(emms-info-metaflac))))

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

(provide 'conf/emms)
