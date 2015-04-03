;; Configuration for Emacs running on Cygwin

(defun translate-dos-path (dos)
  (call-process-return-output "cygpath" dos))

;; Translate dos path in compilation-mode
(defun compilation-find-file--dos-path (orig-fun &rest args)
  (let* ((path (cadr args))
         (new-path (translate-dos-path path))
         (new-args (cons (car args) (cons new-path (cddr args)))))
    (apply orig-fun new-args)))

(advice-add #'compilation-find-file :around #'compilation-find-file--dos-path)

(provide 'conf/cygwin)
