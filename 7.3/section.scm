(require-extension
 syntax-case
 vector-lib
 (srfi 27))
(require '../5.4/section)
(require '../7.1/section)
(module
 section-7.3
 (randomized-partition!
  randomized-quicksort!)
 (import* section-5.4
          swap!)
 (import* section-7.1
          partition-general!
          quicksort-general!)
 (include "../7.3/randomized-quicksort.scm"))
