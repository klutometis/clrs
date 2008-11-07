(define-record-type :prim-datum
  (make-prim-datum key parent enqueued)
  prim-datum?
  (key prim-datum-key set-prim-datum-key!)
  (parent prim-datum-parent set-prim-datum-parent!)
  (enqueued prim-datum-enqueued? set-prim-datum-enqueued!))

(define (minimum-spanning-tree/prim graph root)
  (let ((queue (make-fibonacci-heap #f 0))
        (weight-ref (graph-weight-ref graph))
        (node->queueable
         (make-hash-table eq? hash-by-identity)))
    (for-each
     (lambda (node)
       (set-node-datum! node (make-prim-datum +inf #f #t)))
     (graph-nodes graph))
    (set-prim-datum-key! (node-datum root) 0)
    (for-each
     (lambda (node)
       (let* ((datum (node-datum node))
              (queueable
               (make-fibonacci-node
                (prim-datum-key datum) node #f #f #f #f #f 0)))
         (hash-table-set! node->queueable node queueable)
         (fibonacci-heap-insert! queue queueable)))
     (graph-nodes graph))
    (let iter ()
      (if (not (fibonacci-heap-empty? queue))
          (let* ((queueable (fibonacci-heap-extract-min! queue))
                 (node (fibonacci-node-datum queueable))
                 (datum (node-datum node)))
            (for-each
             (lambda (adjacent-node)
               (let ((adjacent-datum (node-datum adjacent-node))
;;;                      (queueable (hash-table-ref node->queueable adjacent-node))
                     (queueable
                      (cdr (find (lambda (node-queueable)
                                   (debug node-queueable)
                                   (eq? adjacent-node
                                        (car node-queueable)))
                                 (hash-table->alist node->queueable))))
                     (weight (weight-ref node adjacent-node)))
                 (debug queueable)
                 (if (and (prim-datum-enqueued? adjacent-datum)
                          (< weight (prim-datum-key adjacent-datum)))
                     (begin
                       (set-prim-datum-parent! adjacent-datum node)
                       (debug (list
                               (prim-datum-key adjacent-datum)
                               (fibonacci-node-key queueable)
                               weight))
                       (set-prim-datum-key! adjacent-datum weight)
                       (fibonacci-heap-decrease-key! queue queueable weight)))))
             (adjacent-nodes graph node))
            (iter))))))
