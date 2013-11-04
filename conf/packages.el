(setq user-package-list
      '(auctex
        auto-complete
        org
	bbdb
        ggtags
        git-commit-mode
        gitignore-mode
        magit
        jedi
        js2-mode
        lua-mode
        php-mode
        web-mode
        yasnippet))

(add-to-list 'package-archives '("mepla" . "http://melpa.milkbox.net/packages/"))

(provide 'conf/packages)
