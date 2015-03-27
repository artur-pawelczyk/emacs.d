(with-eval-after-load "git-timemachine"
  (defun conf/git-timemachine-show-previous (arg)
    (interactive "P")
    (let ((times (or arg 1)))
      (dotimes (i times)
        (git-timemachine-show-previous-revision))))

  (defun conf/git-timemachine-show-next (arg)
    (interactive "P")
    (let ((times (or arg 1)))
      (dotimes (i times)
        (git-timemachine-show-next-revision))))

  (define-key git-timemachine-mode-map (kbd "p") #'conf/git-timemachine-show-previous)
  (define-key git-timemachine-mode-map (kbd "n") #'conf/git-timemachine-show-next))

(provide 'git-timemachine-fix)
