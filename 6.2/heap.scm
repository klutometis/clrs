(define (left index)
  (- (* (+ index 1) 2) 1))

(define (right index)
  (* (+ index 1) 2))

(define (parent index)
  (- (floor (/ (+ index 1) 2)) 1))

(define (heap-swap! heap i j)
  (swap! (heap-data heap) i j))

(define (heap-ref heap index)
  (list-ref (heap-data heap) index))

(define (heap-length heap)
  (length (heap-data heap)))

(define (heap-set! heap index object)
  (list-set! (heap-data heap) index object))

(define (heap-append! heap object)
  (append! (heap-data heap) (list object)))

(define (heap-delete! key heap)
  (delete! key (heap-data heap)))

(define (heap-drop-right! heap i)
  (drop-right! (heap-data heap) i))

(define (heap-null? heap)
  (null? (heap-data heap)))

(define-record-type :heap
  (make-heap heap-data heap-size)
  heap?
  (heap-data heap-data set-heap-data!)
  (heap-size heap-size set-heap-size!))
