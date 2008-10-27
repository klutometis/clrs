(require-extension
 syntax-case
 (srfi 11))
(require '../20.2/section)
(require '../20.3/section)
(module
 chapter-20
 (fibonacci-heap-change-key!)
 (import section-20.2)
 (import section-20.3)
 (include "../20/fibonacci.scm"))
