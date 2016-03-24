(setq desktop-lazy-idle-delay 1)
(setq desktop-restore-eager 20)


(defun scratch-save-desktop (_)
  (buffer-substring (point-min) (point-max)))

(defun scratch-restore-dekstop (_ _ contents)
  (with-current-buffer (get-buffer-create "*scratch*")
    (erase-buffer)
    (insert contents)))

(add-to-list 'desktop-buffer-mode-handlers '(lisp-interaction-mode . scratch-restore-dekstop))

(add-hook 'lisp-interaction-mode-hook (lambda ()
                                        (when (equal (buffer-name) "*scratch*")
                                          (setq-local desktop-save-buffer #'scratch-save-desktop))))

(provide 'conf/desktop)
