(require-extension
 syntax-case
 foof-loop)
(require '../12.1/section)
(module
 chapter-12
 (rt-insert!
  rt-preorder-tree-map
  figure-12.5)
 (import* section-12.1
          make-bt-node
          bt-node-right
          bt-node-left
          bt-node-datum
          bt-node-key
          set-bt-node-left-right-parent!
          set-bt-node-right!
          set-bt-node-left!
          set-bt-node-key!
          set-bt-node-datum!)
 (include "../12/radix-tree.scm"))
