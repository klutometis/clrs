(require-extension
 syntax-case
 foof-loop
 (srfi 9))
(module
 section-10.3
 (make-sarray
  sarray-data
  sarray-insert!
  sarray-delete!
  sarray-head
  sarray-free
  make-marray
  marray-insert!
  marray-delete!
  marray-key
  marray-next
  marray-prev
  marray-free
  marray-head
  marray-compactify!)
 (include "../10.3/array-list.scm")
 (include "../10.3/marray-list.scm"))
