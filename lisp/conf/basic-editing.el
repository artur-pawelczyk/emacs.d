(defun query-replace--act-on-all (orig from to &optional delimited start end &rest args)
  "Replace on all visible text, not only after point."
  (let ((beg (if mark-active (mark) (point-min)))
        (end (if mark-active (point) (point-max))))
    (apply orig from to delimited beg end args)))

(advice-add 'query-replace :around #'query-replace--act-on-all)
(advice-add 'query-replace-regexp :around #'query-replace--act-on-all)


(defun isearch-symbol-case-sensitive ()
  (interactive)
  (let ((case-fold-search nil))
    (isearch-forward-symbol-at-point)))

(global-set-key (kbd "M-s .") #'isearch-symbol-case-sensitive)


(with-package (subword)
  (global-subword-mode))


(define-key occur-mode-map (kbd "n") #'next-error-no-select)
(define-key occur-mode-map (kbd "p") #'previous-error-no-select)


(when (conf/installed-p 'avy)
  (define-key isearch-mode-map (kbd "C-'") #'avy-isearch)
  (global-set-key (kbd "M-g M-g") #'avy-goto-line))


(setq linum-relative-backend 'display-line-numbers-mode)
(with-package-lazy (prog-mode)
  (if (conf/installed-p 'linum-relative)
      (add-hook 'prog-mode-hook #'linum-relative-mode)))
