;; (require-extension syntax-case foof-loop)

(define (enumerate! fortuita numerata)
  (loop count ((for x (in-vector fortuita)))
        (vector-set! numerata x (+ (vector-ref numerata x) 1))
        (count)))

(define (leq! numerata)
  (loop leq ((for x i (in-vector numerata 1)))
        (vector-set! numerata i (+ x (vector-ref numerata (- i 1))))
        (leq)))

(define (sort! numerata sortita x)
  (let ((count-index (- (vector-ref numerata x) 1)))
    (vector-set! sortita count-index x)
    (vector-set! numerata x count-index)))

(define (vector-max vector)
  (loop ((for x (in-vector vector))
         (with max-x -inf.0 (max x max-x)))
        => max-x))

(define (make-numerata fortuita)
  (let ((max (+ (vector-max fortuita) 1)))
    (make-vector max 0)))

(define (counting-sort fortuita)
  (let* ((sortita (make-vector (vector-length fortuita)))
         (numerata (make-numerata fortuita)))
    (enumerate! fortuita numerata)
    (leq! numerata)
    (loop sort ((for x (in-vector-reverse fortuita)))
          (sort! numerata sortita x)
          (sort))
    sortita))

(let ((fortuita (vector 6 0 2 0 1 3 4 6 1 3 2)))
  (counting-sort fortuita))

;; #(0 0 1 1 2 2 3 3 4 6 6)
