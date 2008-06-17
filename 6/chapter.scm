(require-extension
 syntax-case
 (srfi 1 9 11 26))
(require '../6.5/section)
(require '../6.2/section)
(require '../5.4/section)
(require '../srfi/srfi-70)
(module
 chapter-6
 (build-max-heap-prime
  heap-extract-max-dary
  heap-increase-key-dary
  max-heap-insert-dary
  make-tableau
  tableau-data
  tableauify
  tableau-max-index
  tableau-extract-min
  tableau-insert
  tableau-sort
  tableau-search)
 (import* section-6.5
          max-heap-insert
          heap-maximum)
 (import* section-6.2
          set-heap-size!
          heap-size
          heap-data
          make-heap
          heap-ref
          heap-swap!
          heap-set!
          heap-drop-right!
          heap-null?
          set-heap-data!
          heap-append!)
 (import* section-5.4
          swap!
          list-set!)
 (import* srfi-70
          infinite?
          finite?)
 (include "build-max-heap-prime.scm")
 (include "heap-extract-max-dary.scm")
 (include "young-tableau.scm"))
