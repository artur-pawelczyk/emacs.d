(global-set-key (kbd "C-x C-b") 'ibuffer)

(defun ibuffer-apply-filters ()
  (interactive)
    
  (ibuffer-filter-by-used-mode 'dired-mode)
  (ibuffer-filters-to-filter-group "Dired")
    
  (ibuffer-filter-by-name "\*.*\*")
  (ibuffer-filters-to-filter-group "Emacs")

  (ibuffer-filter-by-used-mode 'shell-mode)
  (ibuffer-filters-to-filter-group "Shell"))

(add-hook 'ibuffer-mode-hook 'ibuffer-apply-filters)

(with-package-lazy (ibuffer)
  (define-key ibuffer-mode-map (kbd "M-o") (if (featurep 'ace-window)
                                               #'ace-window
                                             #'other-window)))

(provide 'conf/buffer-list)
