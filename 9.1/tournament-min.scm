(define (tournament-min list)
  (let ((comparisons (make-hash-table)))
    (define (record-comparison! a b)
      (hash-table-update!/default
       comparisons
       a
       (lambda (comparison) (cons b comparison))
       '()))
    (define (min a b)
      (record-comparison! a b)
      (record-comparison! b a)
      (if (< a b) a b))
    (loop continue ((with list list)
                    (until (null? (cdr list))))
          => (let ((min (car list)))
               (values min
                       (hash-table-ref/default
                        comparisons
                        min
                        '())))
          (let-values (((pairs rest) (divide 2 list)))
            (continue (=> list (map (cut apply min <>) pairs)))))))
