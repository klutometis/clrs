(require-extension
 syntax-case
 foof-loop)
(require '../2.1/section)
(require '../srfi/srfi-70)
(module
 section-8.4
 (bucket-sort)
 (import* section-2.1
          insertion-sort)
 (import* srfi-70
          exact-floor)
 (include "../8.4/bucket-sort.scm"))
