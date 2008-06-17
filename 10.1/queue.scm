(define-record-type :queue
  (make-queue data head tail)
  queue?
  (data queue-data)
  (head queue-head set-queue-head!)
  (tail queue-tail set-queue-tail!))

(define (queue-empty? queue)
  (= (queue-head queue) (queue-tail queue)))

(define (queue-full? queue)
  (= (queue-head queue)
     (modulo (+ (queue-tail queue) 1)
             (vector-length (queue-data queue)))))

(define (enqueue! queue x)
  (if (queue-full? queue)
      (error "Queue full -- ENQUEUE!")
      (let ((data (queue-data queue))
            (tail (queue-tail queue)))
        (vector-set! data tail x)
        (set-queue-tail! queue
                         (modulo (+ tail 1) (vector-length data))))))

(define (dequeue! queue)
  (if (queue-empty? queue)
      (error "Queue empty -- DEQUEUE!")
      (let ((data (queue-data queue))
            (head (queue-head queue)))
        (let ((x (vector-ref data head)))
          (set-queue-head! queue
                           (modulo (+ head 1) (vector-length data)))
          x))))
