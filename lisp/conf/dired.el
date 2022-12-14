(require 'cl-macs)

(with-package-lazy (dired)
  (require 'dired-x))

(autoload 'dired-jump "dired-x" nil :interactive)
(global-set-key (kbd "C-x C-j") #'dired-jump)

(setq dired-listing-switches "-hla")
(setq dired-dwim-target t)
(setq dired-omit-verbose nil)

(with-package-lazy (dired)
  (when (fboundp 'dired-hide-details-mode)
    (add-hook 'dired-mode-hook 'dired-hide-details-mode)
    (define-key dired-mode-map (kbd "C-x M-h") 'dired-hide-details-mode)))

(add-hook 'dired-mode-hook
	  (lambda ()
	    (setq dired-omit-files
		  (concat dired-omit-files "\\|^\\..+$"))))

(defvar-local conf/dired-omit-mode t
  "Use an .dir-locals.el file to override dired-omit-mode for a
  directory.")

(add-to-list 'safe-local-variable-values '(conf/dired-omit-mode . nil))
(add-to-list 'safe-local-variable-values '(conf/dired-omit-mode . t))

(defun conf/dired-maybe-enable-omit-mode ()
  (when conf/dired-omit-mode
    (dired-omit-mode 1)))

(add-hook 'dired-mode-hook #'conf/dired-maybe-enable-omit-mode)

(defvar conf/video-player "mpv")
(defvar conf/pdf-viewer "mupdf")
(setq dired-guess-shell-alist-user
      '(("\\.pdf\\'" conf/pdf-viewer)
	("\\.avi\\'" conf/video-player)
	("\\.flv\\'" conf/video-player)
	("\\.webm\\'" conf/video-player)
	("\\.mp4\\'" conf/video-player)
        ("\\.mp4.part\\'" conf/video-player)
	("\\.mov\\'" conf/video-player)
        ("\\.mkv\\'" conf/video-player)
        ("\\.m4v\\'" conf/video-player)))


(defun find-dired-current (find-args)
  (interactive (list (read-string "Run find: " "-iname ")))
  (find-dired default-directory find-args))

(with-package-lazy (dired)
  (if (conf/installed-p 'fd-dired)
      (define-key dired-mode-map (kbd "C-c f") #'fd-dired)
      (define-key dired-mode-map (kbd "C-c f") #'find-dired-current))
  (define-key dired-mode-map (kbd "X") #'shell-command-run-at-point))


(with-package-lazy (locate)
  (add-hook 'locate-mode-hook (-partial #'set 'conf/dired-omit-mode nil)))


(defun conf/dired--yes-no-all-quit-help (prompt &optional help-msg)
  "Replacement for `dired--yes-no-all-quit-help'.  `help-msg' is ignored"
  (cl-case (read-choice-from-minibuffer prompt '(?y ?n ?a ?q))
    (?y "yes")
    (?n "no")
    (?a "all")
    (?q "quit")))

(with-package-lazy (dired)
  (fset 'dired--yes-no-all-quit-help #'conf/dired--yes-no-all-quit-help))
