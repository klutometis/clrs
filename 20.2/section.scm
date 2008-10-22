(require-extension
 syntax-case
 foof-loop
 vector-lib
 (srfi 9 11))
(require '../util/util)
(require '../srfi/srfi-70)
(module
 section-20.2
 (make-fibonacci-heap
  make-fibonacci-node
  fibonacci-node-key
  fibonacci-heap-insert!
  fibonacci-heap-union!
  fibonacci-heap-roots
  fibonacci-heap-min
  fibonacci-heap-extract-min!
  fibonacci-heap-empty?
  fibonacci-heap->list
  figure-20.3)
 (import* util debug)
 (import* srfi-70 exact-floor)
 (include "../20.2/fibonacci.scm"))
