;; Configuration for Emacs running on Cygwin

(with-package (windows-path)
  (windows-path-activate))

(defun translate-dos-path (dos)
  (call-process-return-output "cygpath" dos))

(defun translate-into-dos-path (path)
  (call-process-return-output "cygpath" "-t" "mixed" path))

;; `C-(' and `C-)' don't work on Windows
(with-package-lazy (smartparens)
  (define-key sp-keymap (kbd "C-c )") #'conf/forward-slurp)
  (define-key sp-keymap (kbd "C-c (") #'sp-backward-slurp-sexp))

(with-package-lazy (dired)
  (define-key dired-mode-map (kbd "b") 'browse-url-of-dired-file))


(defvar linum-mode-suppress-update nil
  "If non-nil, prevents linum-mode from updating.  Meant to be
  used while `hydra-splitter' (resizing windows) is active to make it work faster.")

(defun linum-update-current--maybe-suppress (orig-fun &rest args)
  (unless linum-mode-suppress-update
    (apply orig-fun args)))

(advice-add #'linum-update-current :around #'linum-update-current--maybe-suppress)

(provide 'conf/cygwin)

