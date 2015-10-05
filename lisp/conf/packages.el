(defvar user-package-list
      '(ace-window
        auctex
        bbdb
        auto-complete
        cider
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
        smartparens
        slime
        markdown-mode
        helm
        helm-projectile
        helm-swoop
        helm-c-yasnippet
        swiper ;; provides ivy-mode
        ggtags
        flycheck
        javadoc-lookup
        lacarte
        sql-indent
        s
        dash
        emms
        expand-region
        macrostep
        linum-relative))


(add-to-list 'package-archives '("mepla" . "http://melpa.milkbox.net/packages/"))

(provide 'conf/packages)
