(require-extension
 syntax-case
 foof-loop
 (srfi 9 13 31))
(require '../util/util)
(require '../srfi/srfi-70)
(require '../5.4/section)
(require '../12.1/section)
(module
 section-16.3
 (heapify!
  make-heap
  heap-data
  build-heap!
  heap-extract-extremum!
  heap-empty?
  heapsort!
  heap-insert!
  huffman!
  huffman-codes
  huffman-tree)
 (import* srfi-70 exact-floor)
 (import* section-5.4 swap! list-set!)
 (import* util debug)
 (import* section-12.1
          make-bt-node
          bt-node-left
          set-bt-node-left!
          bt-node-right
          set-bt-node-right!
          bt-node-datum
          bt-node-key
          set-bt-node-key!
          bt-preorder-tree-map)
 (include "../16.3/priority-queue.scm")
 (include "../16.3/huffman.scm"))
