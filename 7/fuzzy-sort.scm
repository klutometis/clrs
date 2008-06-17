(define-record-type :interval
  (make-interval lower upper)
  interval?
  (lower lower)
  (upper upper))

(define (interval->list interval)
  (list (lower interval) (upper interval)))

(define (compare-lowers comparans comparandum comparator)
  (comparans (lower comparandum) (lower comparator)))

(define (orthogonal? comparandum comparator)
  (not (overlap? comparandum comparator)))

(define (overlap? comparandum comparator)
  (and (>= (upper comparandum)
           (lower comparator))
       (<= (lower comparandum)
           (upper comparator))))

(define (fuzzy-partition! vector p r)
  (let ((x (vector-ref vector r))
        (i (- p 1))
        (j (iota (- r p) p)))
    (for-each
     (lambda (j)
       (let ((ref (vector-ref vector j)))
         (if (or (overlap? ref x)
                 (compare-lowers <= ref x))
             (begin (set! i (+ i 1))
                    (vector-swap! vector i j)))))
     j)
    (vector-swap! vector (+ i 1) r)
    (let loop ((k i))
      (if (or (negative? k)
              (orthogonal? (vector-ref vector k) x))
          (values (+ k 1) (+ i 1))
          (loop (- k 1))))))

(define (fuzzy-quicksort! vector p r)
  (if (< p r)
      (let-values (((q-lower q-upper)
                    (fuzzy-partition! vector p r)))
        (fuzzy-quicksort! vector p (- q-lower 1))
        (fuzzy-quicksort! vector (+ q-upper 1) r))))
