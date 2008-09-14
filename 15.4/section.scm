(require-extension
 syntax-case
 array-lib
 array-lib-hof
 foof-loop
 (srfi 1))
(module
 section-15.4
 (lcs-length
  lcs-length/2n
  lcs-length/n
  memoized-lcs-length
  lcs
  lcs/c)
 (include "../15.4/lcs.scm"))
