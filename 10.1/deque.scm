(define make-deque make-queue)
(define (increment x) (+ x 1))
(define (decrement x) (- x 1))
(define (increment-general queue queue-end)
  (modulo (increment (queue-end queue)) (vector-length (queue-data queue))))
(define (decrement-general queue queue-end)
  (modulo (decrement (queue-end queue)) (vector-length (queue-data queue))))
(define increment-head (cut increment-general <> queue-head))
(define increment-tail (cut increment-general <> queue-tail))
(define decrement-head (cut decrement-general <> queue-head))
(define decrement-tail (cut decrement-general <> queue-tail))
(define (enqueue-general! queue x queue-end set-queue-end! crement)
  (if (queue-full? queue)
      (error "Queue full -- ENQUEUE!")
      (let ((data (queue-data queue))
            (end (queue-end queue)))
        (vector-set! data end x)
        (set-queue-end! queue
                        (modulo (crement end) (vector-length data))))))

(define (dequeue-general! queue queue-end set-queue-end! crement)
  (if (queue-empty? queue)
      (error "Queue empty -- DEQUEUE!")
      (let ((data (queue-data queue))
            (end (queue-end queue)))
        (let ((x (vector-ref data end)))
          (set-queue-end! queue
                          (modulo (crement end) (vector-length data)))
          x))))
(define enqueue-tail!
  (cut enqueue-general! <> <> queue-tail set-queue-tail! increment))
(define enqueue-head!
  (cut enqueue-general! <> <> decrement-head set-queue-head! decrement))
(define dequeue-tail!
  (cut dequeue-general! <> decrement-tail set-queue-tail! decrement))
(define dequeue-head!
  (cut dequeue-general! <> increment-head set-queue-head! increment))
