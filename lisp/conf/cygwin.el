;; Configuration for Emacs running on Cygwin

(defun translate-dos-path (dos)
  (call-process-return-output "cygpath" dos))

(defun translate-into-dos-path (path)
  (call-process-return-output "cygpath" "-t" "mixed" path))

;; Translate dos path in compilation-mode
(defun compilation-find-file--dos-path (orig-fun &rest args)
  (let* ((path (cadr args))
         (new-path (translate-dos-path path))
         (new-args (cons (car args) (cons new-path (cddr args)))))
    (apply orig-fun new-args)))

(advice-add #'compilation-find-file :around #'compilation-find-file--dos-path)

;; Call psql with DOS style paths
(defun org-babel-process-file-name--dos-path (orig-fun &rest args)
  (let ((output (apply orig-fun args)))
    (translate-into-dos-path output)))

(advice-add #'org-babel-process-file-name :around #'org-babel-process-file-name--dos-path)

;; `C-(' and `C-)' don't work on Windows
(with-package-lazy 'smartparens
  (define-key sp-keymap (kbd "C-c )") #'conf/forward-slurp)
  (define-key sp-keymap (kbd "C-c (") #'sp-backward-slurp-sexp))

(with-package 'dired
  (define-key dired-mode-map (kbd "b") 'browse-url-of-dired-file))


(provide 'conf/cygwin)
