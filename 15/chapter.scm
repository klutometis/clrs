(require-extension
 syntax-case
 array-lib
 foof-loop
 (srfi 1 13 31 69))
(require '../util/util)
(require '../6.4/section)
(module
 chapter-15
 (memoized-bitonic-euclidean-salesman
  sort-by-x
  construct-path
  print-neatly
  lines
  print-lines)
 (import* util sublist)
 (import* section-6.4 heapsort)
 (include "../15/bitonic-euclidean.scm")
 (include "../15/print-neatly.scm"))
