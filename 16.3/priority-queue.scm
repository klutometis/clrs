;; (define (parent index)
;;   (- (floor (/ (+ index 1) 2)) 1))

(define (parent i)
  (- (exact-floor (/ (+ i 1) 2)) 1))

;; (define (left index)
;;   (- (* (+ index 1) 2) 1))

(define (left i)
  (+ (* i 2) 1))

;; (define (right index)
;;   (* (+ index 1) 2))

(define (right i)
  (+ (* i 2) 1 1))

(define-record-type :heap
  (make-heap key set-key! more? extremum size data)
  heap?
  (key heap-key)
  (set-key! heap-set-key!)
  (more? heap-more?)
  (extremum heap-extremum)
  (size heap-size set-heap-size!)
  (data heap-data set-heap-data!))

(define (heap-length heap)
  (length (heap-data heap)))

(define (heap-swap! heap i j)
  (swap! (heap-data heap) i j))

(define (heap-ref heap i)
  (list-ref (heap-data heap) i))

(define (heap-set! heap i k)
  (list-set! (heap-data heap) i k))

(define (heap-empty? heap)
  (zero? (heap-size heap)))

(define (heapify! heap i)
  (let ((l (left i))
        (r (right i))
        (key (heap-key heap))
        (size (heap-size heap))
        (more? (heap-more? heap)))
    (let ((l-valid? (< l size))
          (r-valid? (< r size)))
      (let ((key-l (if l-valid? (key (heap-ref heap l))))
            (key-r (if r-valid? (key (heap-ref heap r))))
            (key-i (key (heap-ref heap i))))
        (let ((extreme
               (let* ((extreme-l
                       (if (and l-valid?
                                (more? key-l key-i))
                           l
                           i))
                      (key-extreme-l (key (heap-ref heap extreme-l))))
                 (if (and r-valid?
                          (more? key-r key-extreme-l))
                     r
                     extreme-l))))
          (if (not (= extreme i))
              (begin
                (heap-swap! heap i extreme)
                (heapify! heap extreme))))))))

(define (build-heap! heap)
  (set-heap-size! heap (heap-length heap))
  (let ((median (exact-floor (/ (heap-size heap) 2))))
    (loop ((for i (down-from median (to 0))))
          (heapify! heap i))))

(define (heap-extract-extremum! heap)
  (let ((size (heap-size heap)))
    (if (< size 1)
        (error "heap underflow -- EXTRACT-EXTREMUM"))
    (let ((extremum (car (heap-data heap))))
      (heap-set! heap 0 (heap-ref heap (- size 1)))
      (set-heap-size! heap (- size 1))
      (heapify! heap 0)
      extremum)))

(define (heap-adjust-key! heap i k)
  (let ((key (heap-key heap))
        (set-key! (heap-set-key! heap)))
    (let* ((i-ref (heap-ref heap i))
           (i-key (key i-ref)))
      (if ((heap-more? heap) i-key k)
          (error "new key violates heap gradient -- ADJUST-KEY!" k))
      (set-key! i-ref k)
      (loop continue ((with i i)
                      (with parent-i (parent i))
                      (while (> i 0))
                      (while ((heap-more? heap)
                              (key (heap-ref heap i))
                              (key (heap-ref heap parent-i)))))
            (heap-swap! heap i parent-i)
            (continue (=> i parent-i)
                      (=> parent-i (parent parent-i)))))))

(define (heap-insert! heap elt)
  (let ((new-size (+ (heap-size heap) 1))
        (key ((heap-key heap) elt)))
    (set-heap-size! heap new-size)
    (set-heap-data! heap (append (heap-data heap) (list elt)))
    ((heap-set-key! heap) elt (heap-extremum heap))
    (heap-adjust-key! heap (- new-size 1) key)))

(define (heapsort! heap)
  (if (heap-empty? heap)
      '()
      (cons (heap-extract-extremum! heap) (heapsort! heap))))
