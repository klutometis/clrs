(define (greedy-change denominations n)
  (let ((denominations (sort denominations >))
        (iter
         (rec (iter change denominations n)
              (if (null? denominations)
                  change
                  (let* ((denomination (car denominations))
                         (coins (exact-floor (/ n denomination))))
                    (iter (cons (cons denomination coins) change)
                          (cdr denominations)
                          (modulo n denomination)))))))
    (iter '() denominations n)))

(define (power-change c n)
  (let ((iter-k
         (rec (iter-k k)
              (let ((e (expt c k)))
                (if (> e n)
                    (- k 1)
                    (iter-k (+ k 1)))))))
    (let* ((k (iter-k 0))
           (denominations
            (unfold-right (lambda (x) (> x k))
                          (lambda (x) (expt c x))
                          (lambda (x) (+ x 1))
                          0)))
      (greedy-change denominations n))))

(define (dynamic-change denominations n)
  (let ((d (length denominations)))
    (let ((s (make-array '#(#f) `(0 ,d) `(0 ,(+ n 1))))
          (r (make-array '#(#f) `(0 ,d) `(0 ,(+ n 1)))))
      (let ((iter-s
             (rec (iter-s i j)
                  (let ((lookup (if (negative? j) #f (array-ref s i j))))
                    (if lookup
                        lookup
                        (let ((denomination (list-ref denominations i)))
                          (cond ((zero? j)
                                 (array-set! s 0 i j))
                                ((positive? j)
                                 (array-set! s +inf i j)
                                 (loop ((for k (up-from 0 (to (+ i 1)))))
                                       (let ((q (+ (iter-s k (- j denomination)) 1)))
                                         (if (< q (array-ref s i j))
                                             (begin
                                               (array-set! s q i j)
                                               (array-set! r k i j)))))))))
                    (if (negative? j)
                        +inf
                        (array-ref s i j))))))
        (loop ((for k (up-from 0 (to d))))
              (iter-s k n))
        (values s r)))))

(define (make-change denominations s r)
  (let ((d-n (array-dimensions s)))
    (let ((d (car d-n))
          (n (cadr d-n)))
      (let* ((final-tallies
              (make-shared-array s (lambda (i) (list i (- n 1))) d))
             (min-tally (inexact->exact (array-fold min +inf final-tallies)))
             (min-index (list-index (lambda (x) (= x min-tally))
                                    (array->list final-tallies))))
        (let ((iter
               (rec (iter change coins d n)
                    (if (zero? coins)
                        change
                        (let ((next-coin (array-ref r d n))
                              (denomination (list-ref denominations d)))
                          (iter (cons denomination change)
                                (- coins 1)
                                next-coin
                                (- n denomination)))))))
          (iter '() min-tally min-index (- n 1)))))))
