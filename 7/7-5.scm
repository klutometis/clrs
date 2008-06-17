(require-extension
 syntax-case
 check)
(require '../7/chapter)
(import* chapter-7
         median-of-three-quicksort!)

(let ((vector (vector 13 19 9 5 12 8 7 4 11 2 6 21)))
  (median-of-three-quicksort! vector 0 (- (vector-length vector) 1))
  (check vector => '#(2 4 5 6 7 8 9 11 12 13 19 21)))
