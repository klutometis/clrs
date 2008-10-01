(require-extension
 syntax-case
 array-lib
 foof-loop
 (srfi 31 95))
(require '../srfi/srfi-70)
(module
 chapter-16
 (greedy-change
  power-change
  dynamic-change)
 (import* srfi-70 exact-floor)
 (include "../16/change.scm"))
