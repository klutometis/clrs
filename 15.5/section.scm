(require-extension
 syntax-case
 array-lib
 (srfi 31))
(require '../10.1/section)
(module
 section-15.5
 (construct-optimal-bst)
 (import* section-10.1
          make-stack
          pop!
          push!
          peek
          stack-empty?)
 (include "../15.5/bst.scm"))
