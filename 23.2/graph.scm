(define-record-type :edge
  (make-edge whence whither weight)
  edge?
  (whence edge-whence)
  (whither edge-whither)
  (weight edge-weight))

;; (define make-graph alist->hash-table)

(define (graph-edges graph)
;;;   (apply append (hash-table-values graph))
  (apply append (map cdr graph))
  )

;; (define graph-vertices
;;   hash-table-keys
;;   )

(define (graph-vertices graph)
  (map car graph))
