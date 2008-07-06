(require-extension
 syntax-case
 (srfi 9))
(require '../12.1/section)
(module
 section-12.2
 (bt-min
  bt-max
  bt-successor
  figure-12.2)
 (import* section-12.1
          bt-node-right
          bt-node-left
          bt-node-parent
          make-bt-node
          set-bt-node-left-right-parent!)
 (include "../12.2/binary-tree.scm"))
