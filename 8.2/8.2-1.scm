(require-extension
 syntax-case
 check)
(require '../8.2/section)
(import* section-8.2
         counting-sort)
(let ((fortuita (vector 6 0 2 0 1 3 4 6 1 3 2)))
  (check (counting-sort fortuita)
         => '#(0 0 1 1 2 2 3 3 4 6 6)))
