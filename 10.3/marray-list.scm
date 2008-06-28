(define-record-type :marray
  (make-marray key prev next head free)
  marray?
  (key marray-key)
  (prev marray-prev)
  (next marray-next)
  (head marray-head set-marray-head!)
  (free marray-free set-marray-free!))

(define (marray-ref marray i referens)
  (vector-ref (referens marray) i))

(define (marray-key-ref marray i)
  (marray-ref marray i marray-key))

(define (marray-next-ref marray i)
  (marray-ref marray i marray-next))

(define (marray-prev-ref marray i)
  (marray-ref marray i marray-prev))

(define (marray-set! marray i referens value)
  (vector-set! (referens marray) i value))

(define (marray-key-set! marray i value)
  (marray-set! marray i marray-key value))

(define (marray-next-set! marray i value)
  (marray-set! marray i marray-next value))

(define (marray-prev-set! marray i value)
  (marray-set! marray i marray-prev value))

(define (marray-allocate! marray)
  (let* ((free (marray-free marray))
         (next-free (+ free 1)))
    (if (= next-free (marray-length marray))
        ;; Parent continuation?
        (error "Spaceless -- ALLOCATE!")
        (set-marray-free! marray next-free))
    next-free))

(define (marray-free! marray i)
  (let* ((free (marray-free marray))
         (prev-free (- free 1)))
(let ((ref-key (marray-key-ref marray i))
      (ref-prev (marray-prev-ref marray i))
      (ref-next (marray-next-ref marray i))
      (tail-key (marray-key-ref marray free))
      (tail-prev (marray-prev-ref marray free))
      (tail-next (marray-next-ref marray free)))
  (format #t "ref-key: ~A; ref-prev ~A; ref-next ~A; tail-key ~A; tail-prev ~A; tail-next ~%"
          ref-key ref-prev ref-next tail-key tail-prev tail-next)
  (if tail-prev
      (marray-next-set! marray tail-prev i))
  (marray-prev-set! marray i tail-prev)
  (marray-next-set! marray i tail-next)
  (marray-key-set! marray i tail-key)
  (set-marray-free! marray prev-free))))

(define (marray-length marray)
  (vector-length (marray-key marray)))

(define (marray-insert! marray x)
  (let ((free (marray-allocate! marray))
        (head (marray-head marray)))
    (marray-key-set! marray free x)
    (marray-next-set! marray free head)
    (if head
        (marray-prev-set! marray head free))
    (set-marray-head! marray free)
    (marray-prev-set! marray free #f)))

;;; Clears the cell (assigns it to free; see marray-free!); but does
;;; not zero it.
(define (marray-delete! marray i)
  (let ((prev (marray-prev-ref marray i))
        (next (marray-next-ref marray i)))
    (if prev
        (marray-next-set! marray prev next)
        (set-marray-head! marray next))
    (if next
        (marray-prev-set! marray next prev)))
  (marray-free! marray i))
