(require-extension
 syntax-case
 (srfi 9))
(require '../10.1/section)
(module
 section-12.1
 (make-bt-node
  bt-node-datum
  bt-inorder-tree-map
  bt-preorder-tree-map
  bt-postorder-tree-map
  bt-inorder-tree-map/iterative
  exercise-12.1)
 (import* section-10.1
          make-stack
          push!
          pop!
          stack-empty?)
 (include "../12.1/binary-tree.scm"))
