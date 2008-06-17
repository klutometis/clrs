(require-extension
 syntax-case
 vector-lib
 foof-loop
 (srfi 1 26))
(require '../5.4/section)
(require '../srfi/srfi-70)
(module
 section-7.1
 (quicksort!
  quicksort-general!
  partition!
  partition-general!)
 (import* section-5.4
          swap!)
 (import* srfi-70
          exact-floor
          exact-ceiling)
 (include "../7.1/quicksort.scm"))
