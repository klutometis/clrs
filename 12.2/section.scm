(require-extension
 syntax-case
 (srfi 1 9))
(require '../12.1/section)
(module
 section-12.2
 (bt-search
  bt-min
  bt-max
  bt-successor
  bt-predecessor
  figure-12.2/root
  figure-12.2/13
  figure-12.2/17)
 (import* section-12.1
          bt-node-right
          bt-node-left
          bt-node-parent
          bt-node-key
          make-bt-node
          set-bt-node-left-right-parent!)
 (include "../12.2/binary-tree.scm"))
