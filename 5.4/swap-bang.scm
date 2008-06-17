(define (swap! vector/list i j)
  (if (list? vector/list)
      (list-swap! vector/list i j)
      (vector-swap! vector/list i j)))

(define (list-set! list index object)
  (set-car! (drop list index) object))

(define (list-swap! list i j)
  (let ((temp (list-ref list j)))
    (list-set! list j (list-ref list i))
    (list-set! list i temp)))

(define (swap-first! list j)
  (swap! list 0 j))

(define (vector-swap! vector i j)
  (let ((temp (vector-ref vector j)))
    (vector-set! vector j (vector-ref vector i))
    (vector-set! vector i temp)))
