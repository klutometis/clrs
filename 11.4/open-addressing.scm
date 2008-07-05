(define-record-type :oa-table
  (make-oa-table/internal table hash)
  oa-table?
  (table oa-table)
  (hash oa-table-hash))

(define oa-nil #f)

;;; Assumption: keys are natural numbers
(define oa-deleted -1)

(define (oa-nil? ref) (not ref))

(define (oa-deleted? ref) (eq? ref oa-deleted))

(define (make-oa-table length hash)
  (let ((table (make-vector length oa-nil)))
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
       (loop ((for i (up-from 0 (to m)))
              (with j (hash key 0) (hash key i)))
             (let ((ref (oa-table-ref table j)))
               (if (or (oa-nil? ref) (oa-deleted? ref))
                   (begin (oa-table-set! table j key)
                          (return j)))))
       (error "Overflow -- INSERT!")))))

(define (oa-delete! table key)
  (let ((i (oa-search table key)))
    (if i
        (oa-table-set! table i oa-deleted)
        (error "Key existeth nought -- DELETE!"))))

(define (oa-search table key)
  (let ((m (oa-table-length table))
        (hash (oa-table-hash table)))
    (call-with-current-continuation
     (lambda (return)
       (loop ((for i (up-from 0 (to m)))
              (with j (hash key 0) (hash key i)))
             (let ((ref (oa-table-ref table j)))
               (cond ((oa-nil? ref) (return oa-nil))
                     ((= ref key) (return j)))))
       oa-nil))))

(define (linear-probe hash m)
  (lambda (k i) (modulo (+ (hash k) i) m)))

(define (quadratic-probe hash c1 c2 m)
  (lambda (k i) (modulo (+ (hash k) (* c1 i) (* c2 (expt i 2))) m)))

(define (double-hash hash1 hash2 m)
  (lambda (k i) (modulo (+ (hash1 k) (* i (hash2 k))) m)))
