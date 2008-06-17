(define (medial-index p r)
  (+ p (lower-median (- r p))))

;;; Assumes pre-sortment
(define (list-median elts)
  (list-ref (insertion-sort elts)
            (medial-index 0 (- (length elts) 1))))

(define (vector-median! A p r)
  (quicksort! A p r)
  (let ((index (medial-index p r)))
    (vector-ref A index)))

(define (select! A p r i)
  (define (divide d)
    (let* ((lows (loop ((with low p (+ low d))
                        (for lows (listing low))
                        (until (> low r)))
                       => lows))
           (highs (append (cdr (map (cut - <> 1) lows))
                          (list r))))
      (zip lows highs)))
  (let* ((divisions (divide 5))
         ;; median->index map incurs a spatial complexity; can also
         ;; search for the median-of-medians in Theta(r - p).
         (median->index (zip (map (lambda (division)
                                    (vector-median! A
                                                    (car division)
                                                    (cadr division)))
                                  divisions)
                             (iota (- r p) p)))
         (median-of-medians (list-median (map car median->index)))
         (q (partition-k!
             A p r (cadr (assv median-of-medians median->index))))
         (k (+ (- q p) 1)))
    (cond ((< i k) (select! A p (- q 1) i))
          ((> i k) (select! A (+ q 1) r (- i k)))
          (else vector-ref A q))))
