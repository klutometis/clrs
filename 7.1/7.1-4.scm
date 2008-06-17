(require-extension
 syntax-case
 check)
(require '../7.1/section)
(import* section-7.1
         partition-general!
         quicksort-general!)

(define (partition-decreasing! vector p r)
  (partition-general! vector p r >= r))

(define (quicksort-decreasing! vector p r)
  (quicksort-general! vector p r partition-decreasing!))

(let ((vector '#(13 19 9 5 12 8 7 4 21 2 6 11)))
  (quicksort-decreasing! vector 0 (- (vector-length vector) 1))
  (check vector => '#(21 19 13 12 11 9 8 7 6 5 4 2)))
