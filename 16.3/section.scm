(require-extension
 syntax-case
 foof-loop
 (srfi 9))
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
  heapsort!)
 (import* srfi-70 exact-floor)
 (import* section-5.4 swap! list-set!)
 (include "../16.3/priority-queue.scm"))
