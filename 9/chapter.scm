(require-extension syntax-case
                   foof-loop
                   (srfi 1))
(require '../6.4/section)
(require '../9.3/section)
(module
 chapter-9
 (weighted-median-with-sort
  weighted-median-with-select
  elt-weights)
 (import* section-6.4
          heapsort)
 (import* section-9.3
          partition-median!
          lower-median)
 (include "../9/weighted-median.scm"))
