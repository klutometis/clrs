(define (word->string word cardinality)
  (string-trim-right
   (list->string (map (cut (compose integer->char word) <>)
                      (iota cardinality)))
   #\x00))

;;; Could probably do SRFI-13-style selection instead of string->list.
(define (word letters)
  (let* ((letters (string->list letters))
         (length (length letters)))
    (lambda (d)
      (if (< d length)
          (char->integer (list-ref letters d))
          0))))

(define (key-numbers fortuita d p r)
  (loop ((for number (in-vector-reverse fortuita (+ r 1) p))
         (for fortuita (listing (cons (number d) number))))
        => fortuita))

(define (counting-sort!/d fortuita d p r)
  (let ((length (+ (- r p) 1))
        (key-numbers (key-numbers fortuita d p r))
        (numerata (make-hash-table)))
    (let ((sortita (make-vector length 0)))
      (loop ((for key-number (in-list key-numbers))
             (let key (car key-number)))
            (hash-table-update!/default
             numerata
             key
             (lambda (numeratum) (+ numeratum 1))
             0))
      (let ((keys (counting-sort
                   (list->vector (hash-table-keys numerata)))))
        (loop ((for key i (in-vector keys 1)))
              (hash-table-update!
               numerata
               key
               (lambda (numeratum)
                 (+ numeratum
                    (hash-table-ref numerata
                                    (vector-ref keys (- i 1))))))))
      (loop ((for key-number (in-list key-numbers))
             (let key (car key-number))
             (let number (cdr key-number)))
            (let ((count-index (- (hash-table-ref numerata key) 1)))
              (hash-table-update!
               numerata
               key
               (lambda (numeratum) (- numeratum 1)))
              (vector-set! sortita count-index number)))
      (vector-copy! fortuita p sortita))))

(define (radix-sort! words d p r)
  (define (empty?)
    (loop ((for word (in-vector words p (+ r 1)))
           (for sum (summing (word d))))
          => (zero? sum)))
  (call-with-current-continuation
   (lambda (return)
     (if (empty?)
         (return (void)))
     (counting-sort!/d words d p r)
     (let ((numerata (make-hash-table)))
       (loop ((for word (in-vector words p (+ r 1))))
             (hash-table-update!/default
              numerata
              (word d)
              (lambda (numeratum) (+ numeratum 1))
              0))
       (let ((keys (counting-sort
                    (list->vector (hash-table-keys numerata)))))
         (loop ((for key i (in-vector keys 1)))
               (hash-table-update!
                numerata
                key
                (lambda (numeratum)
                  (+ numeratum
                     (hash-table-ref numerata
                                     (vector-ref keys (- i 1)))))))
         ;; Calls radix-sort! on empty dimensions, but bails out.
         (loop ((for key i (in-vector keys))
                (let prev-key
                    (let ((prev-index (- i 1)))
                      (if (negative? prev-index)
                          #f
                          (vector-ref keys prev-index)))))
               (let ((prev-index
                      (if prev-key
                          (hash-table-ref numerata prev-key)
                          0))
                     (index (- (hash-table-ref numerata key) 1))
                     (next-d (+ d 1)))
                 (radix-sort! words
                              next-d
                              prev-index
                              index))))))))

(define (radix-sort fortuita)
  (let ((numerata (make-hash-table)))
    (loop ((for x (in-vector fortuita))
           (let cardinality (cardinality x 10)))
          (hash-table-update!/default numerata
                                      cardinality
                                      (lambda (cardinals)
                                        (cons x cardinals))
                                      '()))
    (loop ((for cardinality
                (up-from 0 (to (+ (apply max (hash-table-keys numerata)) 1))))
           (for sortita (appending
                         (let ((cardinals
                                (hash-table-ref/default numerata cardinality '())))
                           (if (null? cardinals)
                               cardinals
                               (map (lambda (number)
                                      (number->integer number cardinality 10))
                                    (vector->list
                                     (radix-sort-vector
                                      (list->vector (map number cardinals))
                                      cardinality))))))))
          => (list->vector sortita))))
