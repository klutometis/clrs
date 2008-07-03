(require-extension
 syntax-case
 foof-loop
 vector-lib)
(require '../10.2/section)
(module
 section-11.1
 (make-da-table
  make-da-element
  da-insert!
  da-max
  bv-insert
  bv-delete
  bv-search
  make-mda-table
  mda-insert!
  mda-delete!
  mda-search
  mda->vector)
 (import* section-10.2
          dlist-empty?
          make-dlist
          make-dlink-sentinel
          dlist-insert!
          dlist-delete!
          dlink-key
          dlist-map)
 (include "../11.1/direct-address.scm")
 (include "../11.1/bit-vector.scm"))
