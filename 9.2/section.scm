(require-extension
 syntax-case
 foof-loop)
(require '../7.3/section)
(module
 section-9.2
 (generalized-select
  randomized-select
  randomized-select-iter)
 (import* section-7.3
          randomized-partition!)
 (include "../9.2/randomized-select.scm"))
