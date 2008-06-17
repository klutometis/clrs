(define (randomized-partition! vector p r)
  (let ((i (+ p (random-integer (- r p)))))
    (partition-general! vector p r <= i)))

(define (randomized-quicksort! vector p r)
  (quicksort-general! vector p r randomized-partition!))
