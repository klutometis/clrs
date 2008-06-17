(require-extension
 syntax-case
 check)
(require '../7.1/section)
(import* section-7.1
         quicksort!)

(let ((vector '#(13 19 9 5 12 8 7 4 21 2 6 11)))
  (quicksort! vector 0 (- (vector-length vector) 1))
  (check vector => '#(2 4 5 6 7 8 9 11 12 13 19 21)))
