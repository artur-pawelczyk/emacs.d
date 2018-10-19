(require 'ert)

(ert-deftest read-y-or-n-construct-message ()
  (should (equal (read-y-or-n-prompt "Yes?") "Yes? "))
  (should (equal (read-y-or-n-prompt "Yes? ") "Yes? "))
  (should (equal (read-y-or-n-prompt "Yes?" :help)
                 "Yes? (answer 'y' or 'n') ")))


(ert-deftest read-choice-prompt ()
  (should (equal (read-choice-prompt "Choose" '(?a ?b ?c)) "Choose [abc]: ")))
