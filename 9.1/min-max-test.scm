(require-extension
 syntax-case
 check)
(require '../9.1/section)
(import section-9.1)
(let-values (((min max) (min-max '(1 2 3 4))))
  (check min => 1)
  (check max => 4))
