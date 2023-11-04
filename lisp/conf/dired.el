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
    (define-key dired-mode-map (kbd "h") #'dired-omit-mode)))

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



(with-package-lazy (dirvish)
  (dirvish-peek-mode 1)
  (setq dirvish-attributes '(all-the-icons file-size collapse subtree-state))
  (define-key dirvish-mode-map (kbd "a") #'dirvish-quick-access)
  (define-key dirvish-mode-map (kbd "s") #'dirvish-quicksort)
  (define-key dirvish-mode-map (kbd "TAB") #'dirvish-subtree-toggle)
  (define-key dirvish-mode-map (kbd "M-t") #'dirvish-layout-toggle))

(with-package-lazy (dired)
  (if (conf/installed-p 'dirvish)
      (dirvish-override-dired-mode)))


(setq treemacs-collapse-dirs 3)
(setq treemacs-show-hidden-files t)

(with-package-lazy (treemacs)
  (treemacs-project-follow-mode 1)
  (treemacs-tag-follow-mode 1 )
  (treemacs-fringe-indicator-mode 'only-when-focused)
  (setq treemacs-select-when-already-in-treemacs 'close))

(if (conf/installed-p 'treemacs)
    (global-set-key (kbd "M-0") #'treemacs-select-window))
