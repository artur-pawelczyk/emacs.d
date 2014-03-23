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

(provide 'conf/buffer-list)
