(require-extension
 syntax-case
 vector-lib
 (srfi 1 9))
(require '../5.4/section)
(require '../srfi/srfi-70)
(require '../7.1/section)
(require '../2.1/section)
(module
 chapter-7
 (hoare-quicksort!
  hoare-partition!
  stooge-sort!
  tail-quicksort!
  tail-log-quicksort!
  median-of-three-quicksort!
  fuzzy-quicksort!
  make-interval
  interval->list)
 (import* section-5.4
          swap!)
 (import* srfi-70
          exact-floor)
 (import* section-7.1
          partition!)
 (import* section-2.1
          insertion-sort)
 (include "../7/hoare-quicksort.scm")
 (include "../7/stooge-sort.scm")
 (include "../7/tail-quicksort.scm")
 (include "../7/median-of-three-quicksort.scm")
 (include "../7/fuzzy-sort.scm"))
