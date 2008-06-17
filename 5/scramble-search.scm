(define (scramble-search elt list)
  (randomize-in-place list)
  (deterministic-search elt list))
