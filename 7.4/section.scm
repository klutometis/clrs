(require-extension
 syntax-case
 vector-lib)
(require '../2.1/section)
(require '../7.1/section)
(module
 section-7.4
 (insertion-quicksort!)
 (import* section-2.1
          insertion-sort)
 (import* section-7.1
          partition!)
 (include "../7.4/insertion-quicksort.scm"))
