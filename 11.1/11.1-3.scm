(require-extension
 syntax-case
 check
 vector-lib)
(require '../11.1/section)
(require '../10.2/section)
(import section-11.1)
(import section-10.2)
(let ((table (make-mda-table 2))
      (e1 (make-da-element 0 (make-dlink 1 #f #f)))
      (e2 (make-da-element 0 (make-dlink 2 #f #f)))
      (e3 (make-da-element 1 (make-dlink 3 #f #f))))
  (mda-insert! table e1)
  (mda-insert! table e2)
  (mda-insert! table e3)
  (check (mda->vector table) => '#((2 1) (3)))
  (mda-delete! table e2)
  (check (mda->vector table) => '#((1) (3)))
  (check (dlist-map dlink-key (mda-search table 1)) => '(3)))
