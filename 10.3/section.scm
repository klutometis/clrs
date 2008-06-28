(require-extension
 syntax-case
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
  marray-allocate!
  marray-free!
  marray-insert!
  marray-delete!
  marray-key
  marray-free)
 (include "../10.3/array-list.scm")
 (include "../10.3/marray-list.scm"))
