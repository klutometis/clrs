(define-record-type :edge
  (make-edge whence whither weight)
  edge?
  (whence edge-whence)
  (whither edge-whither)
  (weight edge-weight))

(define-record-type :node
  (make-node datum weight)
  node?
  (datum node-datum set-node-datum!)
  (weight node-weight set-node-weight!))

(define-record-type :weighted-graph
  (make-weighted-graph adjacencies weight-ref)
  weighted-graph?
  (adjacencies graph-adjacencies)
  (weight-ref graph-weight-ref))

(define list->adjacencies alist->hash-table)

(define (graph-edges graph)
  (let ((weight-ref (graph-weight-ref graph)))
    (hash-table-fold
     (graph-adjacencies graph)
     (lambda (whence whither edges)
       (append
        (fold
         (lambda (whither edges)
           (cons
            (make-edge whence whither (weight-ref whence whither))
            edges))
         '()
         whither)
        edges))
     '())))

(define (graph-vertices graph)
  (hash-table-keys (graph-adjacencies graph)))

;;; Adding new edges is a pain-in-the-ass: O(|E|).
(define (bidirectional-weight-ref weights)
  (let ((x-y->weight (make-hash-table)))
    (for-each
     (lambda (x-y-weight)
       (let ((x (car x-y-weight))
             (y (cadr x-y-weight))
             (weight (caddr x-y-weight)))
         (hash-table-set! x-y->weight (cons x y) weight)))
     weights)
    (lambda (x y)
;;;       (debug x y)
      (hash-table-ref
       x-y->weight
       (cons x y)
       (lambda ()
         (hash-table-ref
          x-y->weight
          (cons y x)))))))
