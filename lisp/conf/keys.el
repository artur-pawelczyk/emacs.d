(setq god-mode-enable-function-key-translation nil)

(with-package (god-mode)
  (god-mode)
  (global-set-key (kbd "<escape>") #'god-local-mode)
  (define-key god-local-mode-map (kbd ".") #'repeat)
  (define-key god-local-mode-map (kbd "i") #'god-local-mode)
  (global-set-key (kbd "C-x C-1") #'delete-other-windows)
  (global-set-key (kbd "C-x C-2") #'split-window-below)
  (global-set-key (kbd "C-x C-3") #'split-window-right)
  (global-set-key (kbd "C-x C-0") #'delete-window)
  (define-key god-local-mode-map (kbd "[") #'previous-buffer)
  (define-key god-local-mode-map (kbd "]") #'next-buffer)

  (setq-default cursor-type 'bar)
  (add-hook 'god-mode-enabled-hook (lambda () (setq cursor-type 'box)))
  (add-hook 'god-mode-disabled-hook (lambda () (setq cursor-type 'bar)))

  (add-to-list 'god-exempt-major-modes 'vterm-mode))

(with-package (god-mode-isearch)
  (define-key isearch-mode-map (kbd "<escape>") #'god-mode-isearch-activate)
  (define-key god-mode-isearch-map (kbd "<escape>") #'god-mode-isearch-disable))

(with-package-lazy (vterm)
  (define-key vterm-mode-map (kbd "M-]") nil) ;; Unbind `next-buffer' global binding
  (add-hook 'vterm-copy-mode-hook (lambda () (god-local-mode (if vterm-copy-mode 1 -1)))))

(defun conf/god-mode-after-newline ()
  (if (eq (seq-first (this-command-keys-vector)) ?\C-m)
      (god-local-mode -1)))

(with-package-lazy (god-mode)
  (add-hook 'post-self-insert-hook #'conf/god-mode-after-newline))
