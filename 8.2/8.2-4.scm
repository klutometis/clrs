(require-extension
 syntax-case
 check)
(require '../8.2/section)
(import* section-8.2
         enumerator)
(let* ((fortuita (vector 6 0 2 0 1 3 4 6 1 3 2))
       (enumerator (enumerator fortuita)))
  (check (enumerator 0 3) => 6))
