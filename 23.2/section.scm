(require-extension
 syntax-case
 foof-loop
 (srfi 1 9 11 26 69 95))
(require '../util/util)
(require '../20.2/section)
(module
 section-23.2
 (minimum-spanning-tree/kruskal
  figure-23.1
  edge-whence
  edge-whither
  edge-weight
  set-member-datum
  set-member-representative
  make-set/datum
  set-union!
  set-map
  graph-edges
  graph-nodes
  set-head
  set-tail
  node-label)
 (import* util debug)
 (import* section-20.2
          make-fibonacci-heap
          make-fibonacci-heap-node
          fibonacci-heap-insert!
          fibonacci-heap-extract-min!
          fibonacci-heap-decrease-key!)
 (include "../23.2/graph.scm")
 (include "../23.2/set.scm")
 (include "../23.2/kruskal.scm"))
