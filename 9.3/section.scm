(require-extension
 syntax-case
 vector-lib
 foof-loop
 (srfi 1 26))
(require '../9.2/section)
(require '../7.1/section)
(require '../2.1/section)
(require '../srfi/srfi-70)
(module
 section-9.3
 (select!
  balanced-quicksort!
  balanced-select!
  vector-index
  kth-quantiles!
  partition-median!
  k-medial-proximals!
  dual-medians
  lower-median
  medial-index)
 (import* section-7.1
          quicksort!
          quicksort-general!
          partition-general!)
 (import* srfi-70
          exact-floor
          exact-ceiling)
 (import* section-2.1
          insertion-sort)
 (import* section-9.2
          randomized-select
          generalized-select)
 (include "../9.3/balanced-quicksort.scm")
 (include "../9.3/select.scm")
 (include "../9.3/quantiles.scm"))
