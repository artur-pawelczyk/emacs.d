(setq sml/theme 'respectful)
(when (require 'smart-mode-line nil 'noerror)
  (add-hook 'after-init-hook #'sml/setup))

(setq rm-blacklist '(" MRev" " Helm" " AC" " Undo-Tree" " Abbrev" " SP" " yas"))

(defun projectile-disable-mode-line ()
  (setq projectile-mode-line nil))

(eval-after-load "projectile" #'projectile-disable-mode-line)

(provide 'conf/mode-line)
