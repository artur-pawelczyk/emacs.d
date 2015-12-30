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
        org-bullets
        php-mode
        projectile
        solarized-theme
        web-mode
        yasnippet
        smart-mode-line
        smartparens
        slime
        markdown-mode
        helm
        helm-projectile
        swiper ;; provides ivy-mode
        ggtags
        flycheck
        javadoc-lookup
        lacarte
        sql-indent
        s
        dash
        dash-functional
        emms
        expand-region
        macrostep
        linum-relative
        ido-vertical-mode))


(add-to-list 'package-archives '("mepla" . "http://melpa.milkbox.net/packages/"))

(provide 'conf/packages)
