(autoload 'emms "emms" nil :interactive)
(autoload 'emms-pause "emms" nil :interactive)
(autoload 'emms-info-metaflac "emms-info-metaflac")

(with-package-lazy (emms)
  (emms-all)
  (require 'emms-history)
  (emms-history-load)
  (emms-mode-line -1)
  (setq emms-player-list '(emms-player-mplayer))
  (setq emms-source-file-default-directory "~/Music/")
  (setq emms-info-functions (append emms-info-functions '(emms-info-metaflac)))
  (setq emms-playlist-buffer-name "*EMMS Playlist*"))

(with-package-lazy (emms-player-mplayer)
  (let ((new-formats (list "opus")))
    (emms-player-set emms-player-mplayer 'regex (concat "\\`\\(http[s]?\\|mms\\)://\\|"
                                                        (apply #'emms-player-simple-regexp
                                                               (append emms-player-base-format-list new-formats))))))

(defvar conf/add-to-playlist-function (lambda (&rest args) (message "No music player installed")))
(when (conf/installed-p 'emms)
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

(when (conf/installed-p 'emms)
  (global-set-key (kbd "<XF86AudioPlay>") #'emms-pause))
