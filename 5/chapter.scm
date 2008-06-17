(require-extension syntax-case
                   (srfi 27))
(require '../5.4/section)

(module
 chapter-5
 (random-search
  deterministic-search
  scramble-search)
 (import* section-5.4 swap! randomize-in-place)
 (include "random-search.scm")
 (include "deterministic-search.scm")
 (include "scramble-search.scm"))
