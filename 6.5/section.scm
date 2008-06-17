(require-extension syntax-case
                   (srfi 26))
(require '../6.2/section)
(require '../6.4/section)
(module
 section-6.5
 (heap-maximum
  heap-minimum
  heap-extract-max
  heap-extract-min
  heap-increase-key
  heap-decrease-key
  max-heap-insert
  min-heap-insert
  max-heap-delete
  min-heap-delete
  min-heap-merge
  max-heap-merge
  min-heap-merge-append
  max-heap-merge-append
  )
 (import* section-6.2
          heap-ref
          max-heapify
          min-heapify
          heap-set!
          parent
          heap-swap!
          set-heap-size!
          set-heap-data!
          heap-size
          heap-append!
          heap-drop-right!
          make-heap
          heap-data
          heap-null?)
 (import* section-6.4
          heapsort
          heapsort-decreasing)
 (include "../6.5/priority-queue.scm"))
