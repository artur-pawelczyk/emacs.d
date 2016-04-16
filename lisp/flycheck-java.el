;; -*- lexical-binding: t

(require 'dash)
(require 'flycheck)
(require 'projectile)
(require 's)

(defvar flycheck-java-ecj-jar-path ""
  "Full path to Eclipse Java compiler.  \"org.eclipse.jdt.core.*\"")


(defvar-local flycheck-java-project-path "")

(defvar-local flycheck-java-src-dirs nil
  "List of full paths to directories containing source files.")

(defvar-local flycheck-java-classpath nil
  "List of additional JAR files.")

(defvar-local flycheck-java-version "1.8")

(defun flycheck-java-find-jar-files (project-path)
  (mapcar (-partial (-flip #'expand-file-name) flycheck-java-project-path)
          (let ((default-directory project-path))
                          (-filter (-partial #'s-matches? ".jar$") (projectile-current-project-files)))))

(defun flycheck-java-cmd-options ()
  (let* ((jars (append (flycheck-java-find-jar-files flycheck-java-project-path) flycheck-java-classpath))
         (classpath (s-join ":" jars))
         (sources (s-join ":" (mapcar #'expand-file-name flycheck-java-src-dirs))))
    (list "-source" flycheck-java-version
          "-target" flycheck-java-version
          "-classpath" classpath
          "-sourcepath" sources)))

(flycheck-define-checker java
  "Basic Java checker."
  :command ("java" 
            (option "-jar" flycheck-java-ecj-jar-path)
            "-d" "none" "-Xemacs" 
            (eval (flycheck-java-cmd-options))
            source)
  :error-patterns 
  ((warning line-start (file-name) ":" line ": warning:" 
            (message (zero-or-more not-newline)) line-end)
   (error line-start (file-name) ":" line ": error:" 
          (message (zero-or-more not-newline)) line-end))
  :modes java-mode)

(add-to-list 'flycheck-checkers 'java)

(provide 'flycheck-java)
