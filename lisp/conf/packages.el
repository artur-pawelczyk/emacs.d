(defvar user-package-list
  '(
    ace-window
    ag
    auctex
    bbdb
    counsel
    dash
    dash-functional
    easy-kill
    elfeed
    flycheck
    ggtags
    ghub
    hydra
    ido-vertical-mode
    ivy-pass
    js2-mode
    linum-relative
    macrostep
    magit
    markdown-mode
    markdown-mode
    org
    org-bullets
    pdf-tools
    projectile
    s
    smartparens
    smex
    sql-indent
    web-mode
    ))

(setq package-selected-packages
      (when (boundp 'package-selected-packages)
        (delete-dups (append user-package-list package-selected-packages))))

(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") :append)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") :append)
