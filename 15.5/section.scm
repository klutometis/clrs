(require-extension
 syntax-case
 array-lib
 foof-loop
 (srfi 31))
(require '../10.1/section)
(require '../12.1/section)
(module
 section-15.5
 (construct-optimal-bst
  make-optimal-bst
  memoized-bst
  optimal-bst)
 (import* section-10.1
          make-stack
          pop!
          push!
          peek
          (empty? stack-empty?))
 (import* section-12.1
          (make-node make-bt-node)
          (node-key bt-node-key)
          (set-node-left! set-bt-node-left!)
          (set-node-right! set-bt-node-right!)
          (set-node-parent! set-bt-node-parent!)
          (inorder-tree-map bt-inorder-tree-map))
 (include "../15.5/bst.scm"))
