(require-extension
 syntax-rules
 foof-loop
 vector-lib
 (srfi 1 26))
(require '../srfi/srfi-70)
(module
 section-8.3
 (number
  number->integer
  word->string
  counting-sort-d
  radix-sort
  word
  cardinality)
 (import* srfi-70
          exact-floor)
 (include "../8.3/radix-sort.scm"))
