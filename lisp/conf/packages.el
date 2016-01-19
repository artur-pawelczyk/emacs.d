(defvar user-package-list
      '(ace-window
        auctex
        bbdb
        cider
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
        swiper ;; provides ivy-mode
        ggtags
        flycheck
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
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))

(provide 'conf/packages)
