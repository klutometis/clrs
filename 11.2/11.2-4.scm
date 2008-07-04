(require-extension syntax-case check)
(require '../11.2/section)
(import section-11.2)
(let ((table (make-lh-table 3 modulo-3-hash))
      (e1 (make-lh-element 1 1))
      (e2 (make-lh-element 4 2))
      (e3 (make-lh-element 3 3)))
  (lh-table-insert! table e1)
  (lh-table-insert! table e2)
  (lh-table-insert! table e3)
  (check (lh-table-key-data table) => '((3 . 3) (1 . 1) (4 . 2)))
  (lh-table-delete! table e3)
  (check (lh-table-key-data table) => '(() (1 . 1) (4 . 2)))
  (check (lh-table-search table 4) => 2))