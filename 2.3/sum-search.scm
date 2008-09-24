(define (sum-search S x)
  (let* ((S (heapsort S))
         (iter
          (rec (iter i j)
               (if (>= i j)
                   #f
                   (let ((Si (list-ref S i))
                         (Sj (list-ref S j)))
                     (let ((sum (+ Si Sj)))
                       (cond ((= sum x) (values Si Sj))
                             ((> sum x) (iter i (- j 1)))
                             (else (iter (+ i 1) j)))))))))
    (iter 0 (- (length S) 1))))
