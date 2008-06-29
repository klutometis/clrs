(require-extension
 syntax-case
 foof-loop
 (srfi 9))
(require '../10.1/section)
(module
 section-10.4
 (exercise-10.4-1
  figure-10.10
  tree-node-key
  tree-map
  tree-map/iter
  unbounded-tree-map)
 (import* section-10.1
          make-stack
          stack-empty?
          push!
          pop!)
 (include "../10.4/tree.scm"))
