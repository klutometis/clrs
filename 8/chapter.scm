(require-extension
 syntax-case
 foof-loop
 vector-lib
 (srfi 1 11 13 26 27 69 95))
(require '../8.2/section)
(require '../8.3/section)
(require '../srfi/srfi-70)
(module
 chapter-8
 (counting-sort!
  counting-sort!/d
  radix-sort
  radix-sort!
  word
  word->string
  compare-jugs
  compare-jugs-random
  divide
  k-sort)
 (import* section-8.2
          vector-max
          counting-sort)
 (import* srfi-70
          exact-floor)
 (import* section-8.3
          cardinality
          (radix-sort-vector radix-sort)
          number
          number->integer)
 (include "../8/counting-sort-bang.scm")
 (include "../8/radix-sort-cardinality.scm")
 (include "../8/jugs.scm")
 (include "../8/k-sort.scm"))
