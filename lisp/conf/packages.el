(setq user-package-list
      '(auctex
        bbdb
        auto-complete
        cider
        git-commit-mode
        gitignore-mode
        jedi
        js2-mode
        magit
        org
        php-mode
        projectile
        solarized-theme
        web-mode))

(add-to-list 'package-archives '("mepla" . "http://melpa.milkbox.net/packages/"))

(provide 'conf/packages)
