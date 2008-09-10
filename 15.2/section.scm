(require-extension
 syntax-case
 array-lib
 array-lib-hof
 foof-loop
 srfi-1
 srfi-27)
(module
 section-15.2
 (matrix-chain-order
  matrix-multiply
  matrix-chain-multiply
  matrix-chain-multiply/straight
  random-matrix
  random-matrices)
 (include "../15.2/matrix.scm"))
