(require-extension syntax-case check)
(require '../9.3/section)
(import* section-9.3
         balanced-quicksort!
         vector-index)
;;; See page 150; quicksort performs O(n lg n) when it subproblems are
;;; sized n / 2.  balanced-quicksort forces the issue by partitioning
;;; on the median.
(let ((data (vector 3 2 9 0 7 5 4 8 6 1)))
  (balanced-quicksort! data 0 (- (vector-length data) 1))
  (check data => '#(0 1 2 3 4 5 6 7 8 9)))
