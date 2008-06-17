(require-extension
 syntax-case
 foof-loop
 (srfi 11 26 69))
(require '../8/chapter)
(module
 section-9.1
 (min-max
  tournament-min)
 (import* chapter-8
          divide)
 (include "../9.1/min-max.scm")
 (include "../9.1/tournament-min.scm"))
