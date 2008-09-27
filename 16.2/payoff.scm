(define (maximize-payoff A B)
  (let ((A (sort A >))
        (B (sort B >)))
    (fold (lambda (a b product) (* product (expt a b))) 1 A B)))
