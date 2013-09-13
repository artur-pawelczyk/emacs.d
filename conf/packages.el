(setq user-package-list
      '(auctex
        auto-complete
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

(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

(provide 'conf/packages)
