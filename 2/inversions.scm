(define (make-inversion-counter)
  (let* ((inversions 0)
         (merge-count
          (rec (merge-count A p q r)
               (let ((n1 (+ (- q p) 1))
                     (n2 (- r q)))
                 (let ((L (make-vector (+ n1 1) +inf))
                       (R (make-vector (+ n2 1) +inf)))
                   (vector-copy! L 0 A p (+ q 1))
                   (vector-copy! R 0 A (+ q 1) (+ r 1))
                   (loop continue ((for k (up-from p (to (+ r 1))))
                                   (with i 0)
                                   (with j 0))
                         (let ((Li (vector-ref L i))
                               (Rj (vector-ref R j)))
                           (if (<= Li Rj)
                               (begin
                                 (vector-set! A k Li)
                                 (continue (=> i (+ i 1))))
                               (begin
                                 (set! inversions (+ inversions 1))
                                 (vector-set! A k Rj)
                                 (continue (=> j (+ j 1)))))))))))
         (count-inversions
          (rec (count-inversions A p r)
               (if (< p r)
                   (let ((q (exact-floor (/ (+ p r) 2))))
                     (count-inversions A p q)
                     (count-inversions A (+ q 1) r)
                     (merge-count A p q r)))))
         (dispatch
          (lambda (message)
            (case message
              ('inversions inversions)
              ('count-inversions count-inversions)
              (else (error "enrecognized directive -- COUNTER" message))))))
    dispatch))


