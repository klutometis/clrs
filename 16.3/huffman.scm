(define (huffman! frequencies)
  (let* ((n (length frequencies))
         (queue (make-heap bt-node-key
                           set-bt-node-key!
                           <
                           +inf
                           n
                           frequencies)))
    (build-heap! queue)
    (let* ((maybe (lambda (object predicate? transform default)
                    (if (predicate? object)
                        (transform object)
                        default)))
           (iter
            (rec (iter i)
                 (let ((x (maybe queue
                                 (complement heap-empty?)
                                 heap-extract-extremum!
                                 #f))
                       (y (maybe queue
                                 (complement heap-empty?)
                                 heap-extract-extremum!
                                 #f)))
                   (let ((z (make-bt-node
                             (+ (maybe x values bt-node-key 0)
                                (maybe y values bt-node-key 0))
                             (string-append (maybe x values bt-node-datum "")
                                            (maybe y values bt-node-datum ""))
                             #f
                             #f
                             #f)))
                     (if x (set-bt-node-left! z x))
                     (if y (set-bt-node-right! z y))
                     (heap-insert! queue z)
                     (if (positive? i)
                         (iter (- i 1))))))))
      (iter (- n 2))
      (heap-extract-extremum! queue))))

(define (huffman-codes root)
  (let ((mapping '())
        (leaf? (lambda (root)
                 (not (or (bt-node-left root)
                          (bt-node-right root))))))
    (let continue ((root root)
                   (prefix '()))
      (if root
          (begin (continue (bt-node-left root) (append prefix (list 0)))
                 (continue (bt-node-right root) (append prefix (list 1)))
                 (if (leaf? root)
                     (set! mapping (cons (cons prefix (bt-node-datum root))
                                         mapping))))))
    mapping))
