(require 'dash)

(ert-deftest umessage-format-error ()
  (should (equal (umessage-format-error '(quit) "")
                 "Quit"))
  (should (equal (umessage-format-error '(text-read-only) "")
                 "Text is read-only"))
  (should (equal (umessage-format-error '(quit) "Pre")
                 "Pre: Quit"))
  (should (equal (umessage-format-error '(text-read-only) "Pre" 'the-function)
                 "Pre: the-function: Text is read-only")))

(ert-deftest umessage-window-size ()
  (cl-labels ((test-window-height (text)
                                  (with-temp-buffer
                                    (insert text)
                                    (window-total-height (umessage--new-window (current-buffer))))))
    (should (equal (test-window-height "a") 1))
    (should (equal (test-window-height "") 1))
    (should (equal (test-window-height "a\n\a") 2))
    (let ((umessage-window-max-height 3))
      (should (equal (test-window-height "a\na\na\na\na") 3)))))

(ert-deftest umessage-window-properties ()
  (save-window-excursion
    (let* ((buf (umessage--new-buffer (generate-new-buffer-name " *temp*")
                                      "message"))
           (win (umessage--new-window buf)))
      (unwind-protect
          (progn
            (select-window win)
            (should (null mode-line-format))
            (should (null cursor-type))
            (should (equal (point) 1))
            (should (window-parameter (selected-window) 'no-other-window))
            (should (window-dedicated-p)))
        (kill-buffer buf)))))

(ert-deftest umessage-log-only ()
  (cl-letf* ((buf (generate-new-buffer " *temp*"))
             ((symbol-function 'messages-buffer) (-const buf)))
    (unwind-protect
        (progn
          (umessage-log-only "message")
          (should (string-match-p "message" (with-current-buffer buf (buffer-string)))))
      (kill-buffer buf))))

(ert-deftest umessage-inhibit ()
  (cl-letf* (((symbol-function 'umessage--new-buffer) (lambda (&rest args) (should-not "Should not be called")))
             (inhibit-message t))
    (umessage "Hidden message")))
