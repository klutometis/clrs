(define (edit-distance X Y)
  (let ((m (string-length X))
        (n (string-length Y))
        (cost-delete 2)
        (cost-insert 2)
        (cost-copy 3)
        (cost-replace 3)
        (cost-twiddle 2)
        (cost-kill 1))
    (let ((cost (make-array '#(#f) `(0 ,m) `(0 ,n)))
          (op (make-array '#(#f) `(0 ,m) `(0 ,n))))
      (let ((iter-cost
             (rec (iter-cost i j)
                  (let ((c (array-ref cost i j)))
                    (if c
                        c
                        (let ((xi (string-ref X i))
                              (yj (string-ref Y j))
                              (xi-1 (if (zero? i) #f (string-ref X (- i 1))))
                              (yj-1 (if (zero? j) #f (string-ref Y (- j 1)))))
                          (array-set! cost +inf i j)
                          (cond ((and (zero? i) (zero? j))
                                 (array-set! cost 0 i j)
                                 (array-set! op 'noop i j))
                                ((zero? i)
                                 (array-set! cost (* j cost-insert) i j)
                                 (array-set! op `(insert ,yj) i j))
                                ((zero? j)
                                 (array-set! cost (* i cost-delete) i j)
                                 (array-set! op '(delete) i j))
                                (else
                                 (let ((costs (make-hash-table))
                                       (kill
                                        (if (and (= i m) (= j n))
                                            (min (map (lambda (k)
                                                        (+ (iter-cost k n)
                                                           cost-kill)))
                                                 (iota m))
                                            +inf))
                                       (copy
                                        (if (= xi yj)
                                            (+ (iter-cost (- i 1) (- j 1))
                                               cost-copy)
                                            +inf))
                                       (twiddle
                                        (if (and (>= i 2)
                                                 (>= j 2)
                                                 (= xi yj-1)
                                                 (= xi-1 yj))
                                            (+ (iter-cost (- i 2) (- j 2))
                                               cost-twiddle)
                                            +inf))
                                       (replace
                                        (if (= xi yj)
                                            +inf
                                            (+ (iter-cost (- i 1) (- j 1))
                                               cost-replace)))
                                       (delete
                                        (+ (iter-cost (- i 1) j)
                                           cost-delete))
                                       (insert
                                        (+ (iter-cost i (- j 1))
                                           cost-insert)))
                                   (hash-table-set! costs kill `(kill . ,i))
                                   (hash-table-set! costs copy '(copy))
                                   (hash-table-set! costs twiddle '(twiddle))
                                   (hash-table-set! costs replace `(replace . ,yj))
                                   (hash-table-set! costs insert `(insert . ,yj))
                                   (hash-table-set! costs delete '(delete))
                                   ;; Hack! Just alist it.
                                   (let* ((min-cost (inexact->exact
                                                     (apply min (hash-table-keys
                                                                 costs))))
                                          (min-op (hash-table-ref costs
                                                                  min-cost)))
                                     (array-set! cost min-cost i j)
                                     (array-set! op min-op i j)))))
                          (array-ref cost i j)))))))
        (iter-cost (- m 1) (- n 1))
        (values cost op)))))

(define (ops op i j)
  (if (and (zero? i) (zero? j))
      '()
      (let* ((op-arg (array-ref op i j)))
        (cons
         op-arg
         (case (car op-arg)
           ((copy) (ops op (- i 1) (- j 1)))
           ((replace) (ops op (- i 1) (- j 1)))
           ((twiddle) (ops op (- i 2) (- j 2)))
           ((delete) (ops op (- i 1) j))
           ((insert) (ops op i (- j 1)))
           ((kill) (ops op (cdr op-arg) j)))))))
