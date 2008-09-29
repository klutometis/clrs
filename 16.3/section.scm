(require-extension
 syntax-case
 foof-loop
 (srfi 9))
(require '../util/util)
(require '../srfi/srfi-70)
(require '../5.4/section)
(module
 section-16.3
 (heapify!
  make-heap
  heap-data
  build-heap!
  heap-extract-extremum!
  heap-empty?
  heapsort!
  heap-insert!)
 (import* srfi-70 exact-floor)
 (import* section-5.4 swap! list-set!)
 (import* util debug)
 (include "../16.3/priority-queue.scm"))
