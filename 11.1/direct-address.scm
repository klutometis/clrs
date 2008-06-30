(define-record-type :da-element
  (make-da-element key datum)
  da-element?
  (key da-element-key)
  (datum da-element-datum))

(define da-nil #f)

(define (make-da-table length)
  (make-vector length da-nil))

;;; Hashing function: identity
(define (da-search table key)
  (vector-ref table key))

(define (da-insert! table element)
  (vector-set! table
               (da-element-key element)
               (da-element-datum element)))

(define (da-delete! table element)
  (vector-set! table
               (da-element-key element)
               da-nil))

(define (da-elements table)
  (loop ((for x (in-vector table))
         (for elements (listing x (if x))))
        => elements))

(define (da-max table)
  (apply max (da-elements table)))
