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

;;; Thanks, Joseph JaJa.
(define (marray-free! marray i)
  (let* ((free (marray-free marray))
         (prev-free (- free 1)))
(let ((ref-key (marray-key-ref marray i))
      (ref-prev (marray-prev-ref marray i))
      (ref-next (marray-next-ref marray i))
      (tail-key (marray-key-ref marray free))
      (tail-prev (marray-prev-ref marray free))
      (tail-next (marray-next-ref marray free)))
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

(define (marray-swap! marray list free)
  (let ((list-next (marray-next-ref marray list))
        (list-prev (marray-prev-ref marray list))
        (free-next (marray-next-ref marray free))
        (free-prev (marray-prev-ref marray free)))
    (if free-prev
        (marray-next-set! marray free-prev list))
    (if free-next
        (marray-prev-set! marray free-next list))
    (marray-next-set! marray list free-next)
    (marray-prev-set! marray list free-prev)
    (if list-prev
        (marray-next-set! marray list-prev free))
    (if list-next
        (marray-prev-set! marray list-next free))
    (marray-next-set! marray free list-next)
    (marray-prev-set! marray free list-prev)
    (marray-key-set! marray free (marray-key-ref marray list))
    (let ((marray-head (marray-head marray))
          (marray-free (marray-free marray)))
      (if (= marray-free free)
          (set-marray-free! marray list))
      (if (= marray-head list)
          (set-marray-head! marray free)))))

;;; Miss some on the way?
(define (marray-compactify! marray)
  (loop continue ((with list (marray-head marray))
                  (with free (marray-free marray))
                  (while (and list free)))
        (let ((next-list (marray-next-ref marray list))
              (next-free (marray-next-ref marray free)))
          (if (< free list)
              (begin (marray-swap! marray list free)
                     (continue (=> list next-list)
                               (=> free next-free)))
              (continue (=> free next-free))))))
