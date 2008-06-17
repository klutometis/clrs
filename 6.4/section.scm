(require-extension syntax-case
                   (srfi 1))
(require '../6.3/section)
(require '../6.2/section)
(module
 section-6.4
 (heapsort
  heapsort-decreasing)
 (import* section-6.3
          build-max-heap
          build-min-heap)
 (import* section-6.2
          heap-swap!
          heap-length
          set-heap-size!
          heap-size
          max-heapify
          min-heapify
          make-heap
          heap-data)
 (include "../6.4/heapsort.scm"))
