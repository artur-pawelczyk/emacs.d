(with-package-lazy (sql)
  (require 'sql-indent nil :noerror)
  (add-hook 'sql-interactive-mode-hook (lambda () (toggle-truncate-lines 1))))
