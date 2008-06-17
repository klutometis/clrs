(define (max-heapify heap index)
  (heapify heap index max))

(define (min-heapify heap index)
  (heapify heap index min))

(define (heapify heap index comparator)
  (let ((left (left index))
        (right (right index))
        (heap-size (heap-size heap)))
    (let ((index-ref (heap-ref heap index))
          (left-ref (if (> left (- heap-size 1))
                        #f
                        (heap-ref heap left)))
          (right-ref (if (> right (- heap-size 1))
                         #f
                         (heap-ref heap right))))
      (let ((references `((,left-ref . ,left)
                          (,right-ref . ,right)
                          (,index-ref . ,index))))
        (let ((largest
               (cdr (assv (apply comparator (filter number?
                                                    (map car references)))
                          references))))
          (if (equal? largest index)
              heap
              (begin
                (heap-swap! heap index largest)
                (heapify heap largest comparator))))))))
