(require 'dash)

(defvar user-package-list
      '(ag
        ace-window
        auctex
        bbdb
        cider
        js2-mode
        org
        org-bullets
        php-mode
        projectile
        web-mode
        yasnippet
        smartparens
        slime
        markdown-mode
        counsel
        smex
        ggtags
        flycheck
        lacarte
        sql-indent
        s
        dash
        dash-functional
        emms
        easy-kill
        macrostep
        linum-relative
        ido-vertical-mode
        with-editor ;; Required by Magit
        pdf-tools
        hydra
        ghub))

(setq package-selected-packages
      (when (boundp 'package-selected-packages)
        (-distinct (append user-package-list package-selected-packages))))

(add-to-list 'package-archives '("mepla" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
