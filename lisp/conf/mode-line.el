(require 'smart-mode-line)

(setq sml/theme 'respectful)
(eval-after-load 'init-finish '(sml/setup))

(setq rm-blacklist '(" MRev" " Helm" " AC" " Undo-Tree" " Abbrev"))

(defun projectile-disable-mode-line ()
  (setq projectile-mode-line nil))

(eval-after-load "projectile" #'projectile-disable-mode-line)

(provide 'conf/mode-line)
