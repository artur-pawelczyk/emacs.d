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
    flycheck
    ghub
    hydra
    ido-vertical-mode
    ivy
    ivy-hydra
    ivy-pass
    js2-mode
    linum-relative
    macrostep
    magit
    markdown-mode
    org
    org-bullets
    pdf-tools
    projectile
    rich-minority
    s
    smartparens
    smex
    web-mode
    ))

(setq package-selected-packages
      (when (boundp 'package-selected-packages)
        (delete-dups (append user-package-list package-selected-packages))))

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") :append)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") :append)
