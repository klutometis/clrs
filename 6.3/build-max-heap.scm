(define (build-min-heap heap)
  (build-heap heap min-heapify))

(define (build-max-heap heap)
  (build-heap heap max-heapify))

(define (build-heap heap heapify)
  (let ((heap-length (heap-length heap)))
    (set-heap-size! heap heap-length)
    (let ((leaf-cutoff (inexact->exact (floor (/ heap-length 2)))))
      (for-each (cut heapify heap <>)
                (iota leaf-cutoff (- leaf-cutoff 1) -1))
      heap)))
