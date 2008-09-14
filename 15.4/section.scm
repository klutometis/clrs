(require-extension
 syntax-case
 array-lib
 array-lib-hof
 foof-loop
 (srfi 1))
(require '../6.4/section)
(module
 section-15.4
 (lcs-length
  lcs-length/2n
  lcs-length/n
  memoized-lcs-length
  lcs
  lcs/c
  longest-increasing-subsequence)
 (import* section-6.4 heapsort)
 (include "../15.4/lcs.scm"))
