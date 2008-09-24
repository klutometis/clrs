(require-extension
 syntax-case
 vector-lib
 foof-loop)
(require '../srfi/srfi-70)
(require '../9.3/section)
(module
 chapter-2
 (make-inversion-counter)
 (import* section-9.3 medial-index)
 (import* srfi-70 exact-floor)
 (include "../2/inversions.scm"))
