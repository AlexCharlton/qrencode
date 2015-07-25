#!/usr/local/bin/csi -s

(import chicken scheme)
(use qrencode srfi-1 srfi-4)

(let ((str (if (< (length (argv)) 4)
               "http://call-cc.org"
               (last (argv)))))
  (receive (code width) (QR-encode-string str)
    (print "Encoded: " str)
    (newline)
    (do ((v code)
         (i 0 (add1 i)))
        ((= i (* width width)))
      (when (zero? (modulo i width)) (display "\n        "))
      (display (if (zero? (u8vector-ref code i)) "  " "##")))
    (newline)
    (newline)
    (newline)))
