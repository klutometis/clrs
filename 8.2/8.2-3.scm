(require-extension
 syntax-case
 check)
(require '../8.2/section)
(import* section-8.2
         unstable-counting-sort)
(let ((fortuita (vector 6 0 2 0 1 3 4 6 1 3 2)))
  (check (unstable-counting-sort fortuita)
         => '#(0 0 1 1 2 2 3 3 4 6 6)))

;;; Correct, but unstable; identical elements are reversed.
