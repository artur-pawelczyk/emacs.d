(defvar user-package-list
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
        web-mode
        yasnippet
        undo-tree
        smart-mode-line
        markdown-mode
        helm
        helm-projectile))


(add-to-list 'package-archives '("mepla" . "http://melpa.milkbox.net/packages/"))

(provide 'conf/packages)
