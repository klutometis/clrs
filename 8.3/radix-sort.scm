(define (cardinality integer base)
  (loop ((for power (up-from 0))
         (until (> (expt base power) integer))) => power))

(define (integer->digits integer base)
  (let ((cardinality (cardinality integer base)))
    (list-tabulate
     cardinality
     (lambda (i)
       (let* ((modulizer (expt base (- cardinality i)))
              (integrizer (/ modulizer base)))
         (exact-floor (/ (modulo integer modulizer) integrizer)))))))

(define (number->integer number cardinality base)
  (apply + (map (lambda (d) (* (expt base (- cardinality d 1))
                               (number d)))
                (iota cardinality))))

(define (number integer)
  (let ((digits (integer->digits integer 10)))
    (lambda (d) (list-ref digits d))))

(define (word->string word cardinality)
  (list->string (map (cut (compose integer->char word) <>)
                     (iota cardinality))))

(define (word letters)
  (let ((letters (string->list letters)))
    (lambda (d) (char->integer (list-ref letters d)))))

(define (key-numbers fortuita d)
  (loop ((for number (in-vector-reverse fortuita))
         (for fortuita (listing (cons (number d) number))))
        => fortuita))

(define (counting-sort-d fortuita d)
  (let* ((fortuita (key-numbers fortuita d))
         (digits (map car fortuita)))
    (let ((sortita (make-vector (length fortuita)))
          (numerata (make-vector
                     (+ (apply max digits) 1)
                     0)))
      (loop ((for key-number (in-list fortuita)))
            (let ((key (car key-number)))
              (vector-set! numerata key (+ (vector-ref numerata key) 1))))
      (loop ((for x i (in-vector numerata 1)))
            (vector-set! numerata i (+ x (vector-ref numerata (- i 1)))))
      (loop ((for key-number (in-list fortuita)))
            (let ((key (car key-number))
                  (number (cdr key-number)))
              (let ((count-index (- (vector-ref numerata key) 1)))
                (vector-set! sortita count-index number)
                (vector-set! numerata key count-index))))
      sortita)))

(define (radix-sort numbers cardinality)
  (loop ((for d (down-from cardinality (to 0)))
         (with sorted numbers (counting-sort-d sorted d)))
        => sorted))
