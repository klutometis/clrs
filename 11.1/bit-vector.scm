(define (bv-hash key)
  (expt 2 key))

(define (bv-unhash key)
  (inexact->exact (/ (log key) (log 2))))

(define (bv-insert bv key)
  (bitwise-ior bv (bv-hash key)))

(define (bv-delete bv key)
  (bitwise-and bv (bitwise-not (bv-hash key))))

(define (bv-search bv key)
  (let ((element (bitwise-and bv (bv-hash key))))
    (if (positive? element)
        (bv-unhash element)
        #f)))
