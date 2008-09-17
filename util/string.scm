(define (sublist i j list)
  (take (drop list i) (- j i)))
