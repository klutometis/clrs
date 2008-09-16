(define (except? thunk)
  (call-with-current-continuation
   (lambda (return)
     (with-exception-handler
      (lambda (exception) (return #t))
      (lambda () (thunk) #f)))))

(define (round-array array)
  (array-map '#(#f) (lambda (x) (if (number? x)
                                    (round x)
                                    x)) array))
