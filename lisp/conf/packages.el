(defvar user-package-list
  '(
    ace-window
    ag
    counsel
    dash
    dash-functional
    easy-kill
    god-mode
    hydra
    ido-vertical-mode
    ivy
    ivy-hydra
    ivy-pass
    linum-relative
    magit
    projectile
    rich-minority
    s
    smartparens
    smex
    ))

(defvar user-package-list-optional
  '(
    all-the-icons
    auctex
    bbdb
    flycheck
    js2-mode
    macrostep
    org
    org-bullets
    pdf-tools
    treemacs
    treemacs-all-the-icons
    treemacs-magit
    treemacs-projectile
    treemacs-tab-bar
    web-mode
    ))

(setq package-selected-packages
      (when (boundp 'package-selected-packages)
        (delete-dups (append user-package-list package-selected-packages))))

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") :append)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") :append)
