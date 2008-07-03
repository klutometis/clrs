(require-extension syntax-case check)
(require '../11.1/section)
(import section-11.1)

;;; No key storage; empty on arbitrary nil (#f); requires Theta(m) to
;;; find max.
(let ((table (make-da-table 12)))
  (da-insert! table (make-da-element 1 2))
  (da-insert! table (make-da-element 4 4))
  (da-insert! table (make-da-element 2 8))
  (da-insert! table (make-da-element 9 16))
  (check (da-max table) => 16))
