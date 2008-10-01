(require-extension
 syntax-case
 array-lib
 array-lib-hof
 foof-loop
 (srfi 1 31 95))
(require '../srfi/srfi-70)
(require '../util/util)
(module
 chapter-16
 (greedy-change
  power-change
  dynamic-change
  make-change)
 (import* srfi-70 exact-floor)
 (import* util debug)
 (include "../16/change.scm"))
