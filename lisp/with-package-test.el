(require 'ert)

(defmacro should-expand (body expansion)
  "Assert if BODY after macroexpanstion is equal to EXPANSION"
  `(should (equal (macroexpand ',body) ',expansion)))

(ert-deftest with-single-package-lazy ()
  (should-expand (with-package-lazy (a-package) (body))
                 (eval-after-load 'a-package (lambda () (progn (body))))))

(ert-deftest with-single-package-eager ()
  (should-expand (with-package (a-package) (body))
                 (progn
                   (with-package-lazy (a-package) (body))
                   (require 'a-package nil :noerror))))

(ert-deftest with-two-packages-lazy ()
  (should-expand (with-package-lazy (a-package b-package) (body))
                 (eval-after-load 'a-package (lambda ()
                                               (progn (with-package-lazy (b-package) (body)))))))

