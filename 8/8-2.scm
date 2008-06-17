(require-extension
 syntax-case
 check)
(require '../8/chapter)
(import chapter-8)
;;; Not stable
(let ((data (vector 3 2 1 5 4)))
  (counting-sort! data)
  (check data => '#(1 2 3 4 5)))
