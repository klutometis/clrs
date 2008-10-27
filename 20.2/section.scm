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
  figure-20.3
  sever!
  only?
  set-fibonacci-node-child!
  fibonacci-node-right
  root-list-append!
  set-fibonacci-node-degree!
  fibonacci-node-degree
  set-fibonacci-node-parent!
  fibonacci-node-mark
  set-fibonacci-node-mark!
  fibonacci-node-parent
  set-fibonacci-heap-min!
  fibonacci-node-child
  set-fibonacci-node-key!
  children)
 (import* util debug)
 (import* srfi-70 exact-floor)
 (include "../20.2/fibonacci.scm"))
