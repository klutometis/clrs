(require-extension
 syntax-case
 (srfi 9))
(require '../util/util)
(module
 section-20.2
 (make-fibonacci-heap
  make-fibonacci-node
  fibonacci-node-key
  fibonacci-heap-insert!
  fibonacci-heap-union!
  fibonacci-heap-roots)
 (import* util debug)
 (include "../20.2/fibonacci.scm"))
