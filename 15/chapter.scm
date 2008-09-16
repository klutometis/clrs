(require-extension
 syntax-case
 array-lib
 foof-loop
 (srfi 31 69))
(require '../6.4/section)
(module
 chapter-15
 (memoized-bitonic-euclidean-salesman
  sort-by-x
  construct-path)
 (import* section-6.4 heapsort)
 (include "../15/bitonic-euclidean.scm"))
