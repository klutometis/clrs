(require-extension syntax-case
                   vector-lib
                   (srfi 9))
(require '../5.4/section)

(module
 section-6.2
 (max-heapify
  min-heapify
  make-heap
  heap-data
  set-heap-size!
  set-heap-data!
  heap-size
  heap-ref
  heap-length
  heap-swap!
  heap-set!
  heap-append!
  heap-delete!
  heap-drop-right!
  heap-null?
  parent)
 (import* section-5.4
          swap!
          list-set!)
 (include "../6.2/heap.scm")
 (include "../6.2/max-heapify.scm"))
