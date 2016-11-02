;; -*- lexical-binding: t -*-

(require 'ert)

(ert-deftest shell-command-sentinel--max-output--small-buffer ()
  (let* ((input-string (make-string 10 ?x))
         (actual-string (with-temp-buffer
                          (insert input-string)
                          (shell-command-sentinel--get-output (current-buffer)))))
    (should (equal input-string actual-string))))

(ert-deftest shell-command-sentinel--max-output--large-buffer ()
  (let* ((shell-command-sentinel--max-output 10)
         (input-string (make-string 20 ?x))
         (actual-string (with-temp-buffer
                          (insert input-string)
                          (shell-command-sentinel--get-output (current-buffer)))))
    (should (equal (length actual-string) shell-command-sentinel--max-output))))

(ert-deftest shell-command-new-buffer-name ()
  (should (equal (shell-command-new-buffer-name "program") "*program: shell-command*")))

(ert-deftest shell-command-new-buffer-name--unique-name ()
  (let ((first-buffer (shell-command-new-buffer-name "program")))
    (unwind-protect
        (progn
          (get-buffer-create first-buffer)
          (should (equal (shell-command-new-buffer-name "program") "*program: shell-command<2>*")))
      (kill-buffer first-buffer))))

(ert-deftest shell-command-new-buffer-name--omit-vars ()
  (should (equal (shell-command-new-buffer-name "A_VAR=:1 program") "*program: shell-command*")))

(ert-deftest shell-command-new-buffer-name--handle-extended-command ()
  (should (equal (shell-command-new-buffer-name "git log --pretty=oneline") "*git-log: shell-command*")))

(ert-deftest shell-command-advice--generate-name ()
  (let* ((last-buffer-name "")
         (run-shell-fn (lambda (command &optional out-buffer err-buffer)
                         (setq last-buffer-name out-buffer))))
    (shell-command--set-buffer-name run-shell-fn "program")
    (should (string-match-p "program" last-buffer-name))
    (shell-command--set-buffer-name run-shell-fn "program" "my-buffer")
    (should (equal last-buffer-name "my-buffer"))))

(ert-deftest shell-command-get-real-command ()
  (should (equal (conf/shell-get-real-command '("ls")) '("ls")))
  (should (equal (conf/shell-get-real-command '("ls" "-la")) '("ls" "-la")))
  (should (equal (conf/shell-get-real-command '("bash" "-c" "ls" "-la")) '("ls" "-la")))
  (should (equal (conf/shell-get-real-command '("/bin/bash" "-c" "ls" "-la")) '("ls" "-la"))))

(ert-deftest shell-command-save-command ()
  (with-temp-buffer
    (cl-letf* (((symbol-function 'get-buffer-process) (-const 'fake-process))
               ((symbol-function 'process-command) (lambda (process)
                                                     (if (eq process 'fake-process)
                                                         '("fake-command")
                                                       (error "Expected a fake object")))))
      (shell-command-save-command)
      (should (equal shell-command-last-command '("fake-command"))))))


(cl-letf* (((symbol-function 'message) (lambda (&rest args) "shit")))
  (message 'a))
