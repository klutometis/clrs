(define-record-type :sarray
  (make-sarray data head free)
  sarray?
  (data sarray-data)
  (head sarray-head set-sarray-head!)
  (free sarray-free set-sarray-free!))

(define sarray-offsets '((key . 0)
                         (next . 1)
                         (prev . 2)))

(define sarray-addresses 3)

(define (sarray-ref sarray i key)
  (vector-ref (sarray-data sarray)
              (sarray-address sarray i key)))

(define (sarray-set! sarray i key value)
  (vector-set! (sarray-data sarray)
               (sarray-address sarray i key)
               value))

(define (sarray-address sarray i key)
  (+ (* sarray-addresses i)
     (cdr (assv key sarray-offsets))))

(define (sarray-key sarray i)
  (sarray-ref sarray i 'key))

(define (sarray-next sarray i)
  (sarray-ref sarray i 'next))

(define (sarray-prev sarray i)
  (sarray-ref sarray i 'prev))

(define (set-sarray-key! sarray i value)
  (sarray-set! sarray i 'key value))

(define (set-sarray-next! sarray i value)
  (sarray-set! sarray i 'next value))

(define (set-sarray-prev! sarray i value)
  (sarray-set! sarray i 'prev value))

(define (sarray-allocate! sarray)
  (let ((free (sarray-free sarray)))
    (if free
        (let ((next-free (sarray-next sarray free)))
          (set-sarray-free! sarray next-free)
          free)
        (error "Out of space -- ALLOCATE!"))))

(define (sarray-free! sarray i)
  (set-sarray-next! sarray i (sarray-free sarray))
  (set-sarray-free! sarray i))

(define (sarray-insert! sarray x)
  (let ((free (sarray-allocate! sarray))
        (head (sarray-head sarray)))
    (set-sarray-key! sarray free x)
    (set-sarray-next! sarray free head)
    (if head
        (set-sarray-prev! sarray head free))
    (set-sarray-head! sarray free)
    (set-sarray-prev! sarray free #f)))

;;; Clears the cell (assigns it to free; see sarray-free!); but does
;;; not zero it.
(define (sarray-delete! sarray i)
  (let ((prev (sarray-prev sarray i))
        (next (sarray-next sarray i)))
    (if prev
        (set-sarray-next! sarray prev next)
        (set-sarray-head! sarray next))
    (if next
        (set-sarray-prev! sarray next prev)))
  (sarray-free! sarray i))
