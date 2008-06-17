(require-extension
 syntax-case
 check)
(require '../7/chapter)
(import* chapter-7
         make-interval
         interval->list
         fuzzy-quicksort!)
;;; Achieves Theta(n) in worst case by defining a q-lower and q-upper
;;; of contiguous overlapping intervals; they are guaranteed to be
;;; lower than the pivot since it sorts on <= || overlap?.
(let ((vector (vector
               (make-interval 1 9)
               (make-interval 2 9)
               (make-interval 3 9)
               (make-interval 4 9)
               (make-interval 5 9)
               (make-interval 6 9)
               (make-interval 7 9)
               (make-interval 8 9)
               (make-interval 9 9))))
  (fuzzy-quicksort! vector 0 (- (vector-length vector) 1))
  (check (vector-map (lambda (i x) (interval->list x)) vector)
         => '#((1 9) (2 9) (3 9) (4 9) (5 9) (6 9) (7 9) (8 9) (9 9))))

