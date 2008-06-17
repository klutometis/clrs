(define (heapsort-general data build-heap heapify)
  (let ((heap (make-heap (list-copy data) (length data))))
    (build-heap heap)
    (let ((decremented-heap-length (- (heap-length heap) 1)))
      (for-each
       (lambda (index)
         (heap-swap! heap 0 index)
         (set-heap-size! heap (- (heap-size heap) 1))
         (heapify heap 0))
       (iota decremented-heap-length
             decremented-heap-length
             -1)))
    (heap-data heap)))

(define (heapsort-decreasing data)
  (heapsort-general data build-min-heap min-heapify))

(define (heapsort data)
  (heapsort-general data build-max-heap max-heapify))
