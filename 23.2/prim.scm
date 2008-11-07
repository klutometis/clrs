(define-record-type :prim-datum
  (make-prim-datum key parent enqueued)
  prim-datum?
  (key prim-datum-key set-prim-datum-key!)
  (parent prim-datum-parent set-prim-datum-parent!)
  (enqueued prim-datum-enqueued? set-prim-datum-enqueued!))

(define (minimum-spanning-tree/prim graph root)
  (let ((nodes (graph-nodes graph)))
    (let ((queue (make-heap (compose prim-datum-key node-datum)
                            (lambda (node key)
                              (set-prim-datum-key! (node-datum node) key))
                            <
                            +inf
                            (length nodes)
                            nodes))
          (weight-ref (graph-weight-ref graph)))
      (for-each
       (lambda (node)
         (set-node-datum! node (make-prim-datum +inf #f #t)))
       nodes)
      (set-prim-datum-key! (node-datum root) 0)
      (build-heap! queue)
      (let iter ()
        (if (not (heap-empty? queue))
            (let* ((node (heap-extract-extremum! queue)) 
                   (datum (node-datum node)))
              (for-each
               (lambda (adjacent-node)
                 (let ((adjacent-datum (node-datum adjacent-node))
                       (weight (weight-ref node adjacent-node)))
                   (if (and (prim-datum-enqueued? adjacent-datum)
                            (< weight (prim-datum-key adjacent-datum)))
                       (begin
                         (set-prim-datum-parent! adjacent-datum node)
                         (debug (list
                                 (node-label adjacent-node)
                                 (map node-label (heap-data queue))
                                 (member adjacent-node (heap-data queue))))
                         (heap-adjust-key!/elt queue adjacent-node weight)))))
               (adjacent-nodes graph node))
              (iter)))))))
