(ert-deftest umessage-format-error ()
  (should (equal (umessage-format-error '(quit) "")
                 "Quit"))
  (should (equal (umessage-format-error '(text-read-only) "")
                 "Text is read-only"))
  (should (equal (umessage-format-error '(quit) "Pre")
                 "Pre: Quit"))
  (should (equal (umessage-format-error '(text-read-only) "Pre" 'the-function)
                 "Pre: the-function: Text is read-only")))
