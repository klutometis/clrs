(require-extension syntax-case
                   vector-lib
                   (srfi 27))

(module
 section-5.4
 (randomize-in-place
  randomize-in-place-marceau
  randomize-in-place-kelp
  randomize-in-place-cyclic
  swap!
  list-set!)
 (include "../5.4/swap-bang.scm")
 (include "../5.4/randomize-in-place.scm"))
