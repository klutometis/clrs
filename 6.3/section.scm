(require-extension syntax-case
                   (srfi 1 26))
(require '../6.2/section)

(module
 section-6.3
 (build-max-heap
  build-min-heap)
 (import* section-6.2
          make-heap
          heap-length
          set-heap-size!
          max-heapify
          min-heapify
          heap-data)
 (include "../6.3/build-max-heap.scm"))
