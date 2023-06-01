(require 'dash)
(require 'subr-x)


(defun conf/file-name->package (file-name)
  (string-join (->> (split-string file-name "/")
                    (-drop-while (lambda (e) (not (equal "java" e))))
                    cdr
                    -butlast)
               "."))


;; Maven
(defvar-local conf/mvn-custom-sourcepath '())

(defun conf/mvn-sourcepath (project-root)
  (let* ((src (directory-files-recursively project-root "^java$" :include-dirs))
         (main (-filter (-partial #'string-match-p "/main/") src))
         (test (-filter (-partial #'string-match-p "/test/") src))
         (sourcepath (string-join (append main test conf/mvn-custom-sourcepath) ":")))
    sourcepath))

(defun conf/mvn-classpath (project-root)
  (string-join
   (directory-files (find-nearest-directory project-root "target")
                    :full "\\.jar$")
   ":"))

(defvar conf/jdb-program "jdb")
(defvar-local conf/mvn-program "mvn")
(defvar-local conf/mvn-arguments '())

(defun conf/maybe-project-root ()
  "Project root or current directory if project information is not available."
  (if (fboundp 'projectile-project-root)
      (let ((projectile-require-project-root))
        (projectile-project-root))
    default-directory))

(defvar conf/jdb-run-format "%j -sourcepath%s -classpath%c")
(with-package-lazy (realgud)
  (setq conf/jdb-run-format "%j -sourcepath %s -classpath %c"))

(defvar conf/jdb-attach-format "%j -attach %u -sourcepath%s")
(with-package-lazy (realgud)
  (setq conf/jdb-attach-format "%j -attach %u -sourcepath %s"))

(defun conf/mvn-jdb (project-root)
  (interactive "D")
  (jdb (format-spec conf/jdb-run-format
                    `((?j . ,conf/jdb-program)
                      (?s . ,(conf/mvn-sourcepath project-root))
                      (?c . ,(conf/mvn-classpath project-root))))))

(defun conf/mvn-jdb-attach (project-root url)
  (interactive (list (conf/maybe-project-root)
                     (read-from-minibuffer "URL: " "localhost:5005")))
  (jdb (format-spec conf/jdb-attach-format
                    `((?j . ,conf/jdb-program)
                      (?s . ,(conf/mvn-sourcepath project-root))
                      (?u . ,url)))))

(defun conf/mvn-test (test-name &optional debug)
  (conf/mvn-run "test"
                (list (concat "-Dtest=" test-name)
                      (if debug "-Dmaven.surefire.debug" "")
                      "-Dsurefire.useFile=false")))

(defun conf/mvn-run (command &optional args)
  (let ((default-directory (conf/maybe-project-root)))
    (compile (format "%s %s %s"
                     conf/mvn-program
                     command
                     (string-join (append args conf/mvn-arguments) " ")))))

(defun conf/mvn-test-current-file (&optional debug)
  (interactive "P")
  (require 'java-parser)
  (conf/mvn-test (java-full-class-at-point) debug))

(defun conf/mvn-test-current-method (&optional debug)
  (interactive "P")
  (require 'java-parser)
  (conf/mvn-test (concat (java-full-class-at-point) "#" (java-method-at-point)) debug))

(with-package-lazy (cc-mode)
  (define-key java-mode-map (kbd "C-c d") #'conf/mvn-jdb-attach)
  (define-key java-mode-map (kbd "C-c D") #'conf/mvn-jdb)
  (define-key java-mode-map (kbd "C-c t") #'conf/mvn-test-current-file)
  (define-key java-mode-map (kbd "C-c T") #'conf/mvn-test-current-method))


(when (conf/installed-p 'ggtags)
  (add-hook 'java-mode-hook #'ggtags-mode))

(when (conf/installed-p 'lsp-java)
  (add-hook 'java-mode-hook #'lsp))

(with-package-lazy (lsp)
  (add-hook 'lsp-mode-hook (lambda () (ggtags-mode -1))))


;; Keybindings
(with-package-lazy (cc-mode)
  (define-key java-mode-map (kbd "M-.") #'xref-find-definitions))


