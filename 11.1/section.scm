(require-extension
 syntax-case
 foof-loop)
(module
 section-11.1
 (make-da-table
  make-da-element
  da-insert!
  da-max
  bv-insert
  bv-delete
  bv-search)
 (include "../11.1/direct-address.scm")
 (include "../11.1/bit-vector.scm"))
