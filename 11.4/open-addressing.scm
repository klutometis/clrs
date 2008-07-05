(define-record-type :oa-table
  (make-oa-table/internal table hash)
  oa-table?
  (table oa-table)
  (hash oa-table-hash))

(define (make-oa-table length hash)
  (let ((table (make-vector length #f)))
    (make-oa-table/internal table hash)))

(define (oa-table-length table)
  (vector-length (oa-table table)))

(define (oa-table-ref table i)
  (vector-ref (oa-table table) i))

(define (oa-table-set! table i x)
  (vector-set! (oa-table table) i x))

(define (oa-insert! table key)
  (let ((m (oa-table-length table))
        (hash (oa-table-hash table)))
    (call-with-current-continuation
     (lambda (return)
       (loop ((for i (up-from 0 (to m))))
             (let ((j (hash key i)))
               (if (not (oa-table-ref table j))
                   (begin (oa-table-set! table j key)
                          (return j)))))
       (error "Overflow -- INSERT!")))))

(define (linear-probe hash m)
  (lambda (k i) (modulo (+ (hash k) i) m)))

(define (quadratic-probe hash c1 c2 m)
  (lambda (k i) (modulo (+ (hash k) (* c1 i) (* c2 (expt i 2))) m)))

(define (double-hash hash1 hash2 m)
  (lambda (k i) (modulo (+ (hash1 k) (* i (hash2 k))) m)))
