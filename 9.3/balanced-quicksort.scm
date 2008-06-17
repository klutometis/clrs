(define (lower-median n)
  (- (exact-floor (/ (+ n 1) 2)) 1))

(define (upper-median n)
  (- (exact-ceiling (/ (+ n 1) 2)) 1))

(define (partition-median! A p r)
  (partition-nth! A p r (lower-median (+ (- r p) 1))))

(define (partition-nth! A p r n)
  ;; Could use fancy select!, but in case we want to transition to a
  ;; select-x!, it would introduce a circular dependency.
  (let ((x (randomized-select A p r n)))
    (partition-x! A p r x)))

(define (vector-index A p r ur-x)
  (loop ((for x i (in-vector A p r))
         (until (= x ur-x)))
        => i))

(define (partition-x! A p r x)
  (partition-k! A p r (vector-index A p r x)))

(define (partition-k! A p r k)
  (partition-general! A p r <= k))

(define (balanced-quicksort! A p r)
  (quicksort-general! A p r partition-median!))

(define (balanced-select! A p r i)
  (generalized-select A p r i partition-median!))
