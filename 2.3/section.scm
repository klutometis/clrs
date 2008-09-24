(require-extension
 syntax-case
 (srfi 31))
(require '../6.4/section)
(module
 section-2.3
 (sum-search)
 (import* section-6.4 heapsort)
 (include "../2.3/sum-search.scm"))
