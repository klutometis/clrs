(define (huffman! frequencies)
  (let* ((n (length frequencies))
         (queue (make-heap bt-node-key
                           set-bt-node-key!
                           <
                           +inf
                           n
                           frequencies)))
    (build-heap! queue)
    (let ((iter
            (rec (iter i)
                 (let ((x (heap-extract-extremum! queue))
                       (y (heap-extract-extremum! queue)))
                   (let ((z (make-bt-node
                             (+ (bt-node-key x)
                                (bt-node-key y))
                             (string-append (bt-node-datum x)
                                            (bt-node-datum y))
                             #f
                             #f
                             #f)))
                     (if x (set-bt-node-left! z x))
                     (if y (set-bt-node-right! z y))
                     (heap-insert! queue z)
                     (if (positive? i) (iter (- i 1))))))))
      (iter (- n 1 1))
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

(define (huffman-tree root)
  (bt-preorder-tree-map (lambda (frequency) (list (bt-node-key frequency)
                                                  (bt-node-datum frequency)))
                        root))
