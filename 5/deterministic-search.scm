(define (deterministic-search elt list)
  (cond ((null? list) #f)
        ((= (car list) elt) #t)
        (else (deterministic-search elt (cdr list)))))
