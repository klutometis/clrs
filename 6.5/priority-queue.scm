(define (heap-maximum heap)
  (heap-ref heap 0))

(define (heap-minimum heap)
  (heap-ref heap 0))

(define (heap-extract-max heap)
  (heap-extract heap heap-maximum max-heapify))

(define (heap-extract-min heap)
  (heap-extract heap heap-minimum min-heapify))

(define (heap-extract heap extremum heapify)
  (if (negative? (heap-size heap))
      (error "Heap underflow -- HEAP-EXTRACT-MAX" (heap-size heap))
      (let ((max (extremum heap))
            (heap-size (- (heap-size heap) 1)))
        (heap-set! heap 0 (heap-ref heap heap-size))
        (heap-drop-right! heap 1)
        (set-heap-size! heap heap-size)
        (heapify heap 0)
        max)))

(define (heap-increase-key heap index key)
  (heap-crease-key heap index key <))

(define (heap-decrease-key heap index key)
  (heap-crease-key heap index key >))

(define (heap-crease-key heap index key comparator)
  (if (comparator key (heap-ref heap index))
      (error "New key incomparate -- HEAP-CREASE-KEY" key)
      (begin
        (heap-set! heap index key)
        (let iter ((index index)
                   (parent-index (parent index)))
          (if (not (and (positive? index)
                        (< index (heap-size heap))
                        (< parent-index (heap-size heap))
                        (comparator (heap-ref heap parent-index)
                                    (heap-ref heap index))))
              heap
              (begin
                (heap-swap! heap index parent-index)
                (iter parent-index (parent parent-index))))))))

(define (max-heap-insert heap key)
  (heap-insert heap key -inf.0 heap-increase-key))

(define (min-heap-insert heap key)
  (heap-insert heap key +inf.0 heap-decrease-key))

(define (heap-insert heap key infimum creasor)
  (let ((heap-size (+ (heap-size heap) 1)))
    (set-heap-size! heap heap-size)
    (if (heap-null? heap)
        (set-heap-data! heap (list infimum))
        (heap-append! heap infimum))
    (creasor heap (- heap-size 1) key)
    heap))

(define (max-heap-delete heap index)
  (heap-delete heap index max-heapify))

(define (min-heap-delete heap index)
  (heap-delete heap index min-heapify))

(define (heap-delete heap index heapify)
  (let ((heap-size (- (heap-size heap) 1)))
    (heap-set! heap index (heap-ref heap heap-size))
    (heap-drop-right! heap 1)
    (set-heap-size! heap heap-size)
    (heapify heap index)
    heap))

(define (min-heap-merge . sorted-lists)
  (heap-merge sorted-lists min-heap-insert heapsort))

(define (max-heap-merge . sorted-lists)
  (heap-merge sorted-lists max-heap-insert heapsort-decreasing))

(define (heap-merge sorted-lists heap-insert heapsort)
  (let ((heap (make-heap '() 0)))
    (let iter ((sorted-lists sorted-lists))
      (if (any null? sorted-lists)
          (heapsort (heap-data heap))
          (let ((tuple (map car sorted-lists)))
            (for-each (cut heap-insert heap <>)
                      tuple)
            (iter (map cdr sorted-lists)))))))

(define (min-heap-merge-append . sorted-lists)
  (heap-merge-append sorted-lists min-heap-insert heapsort))

(define (max-heap-merge-append . sorted-lists)
  (heap-merge-append sorted-lists max-heap-insert heapsort-decreasing))

(define (heap-merge-append sorted-lists heap-insert heapsort)
  (let ((heap (make-heap '() 0)))
    (for-each (cut heap-insert heap <>)
              (apply append sorted-lists))
    (heapsort (heap-data heap))))
