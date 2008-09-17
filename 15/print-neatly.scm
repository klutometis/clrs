(define (print-neatly M w)
  (let* ((n (length w))
         (dim `(0 ,n)))
    (let ((line (make-array '#(#f) dim dim))
          (cost (make-array '#(#f) `(-1 ,n)))
          (break (make-array '#(#f) `(-1 ,n)))
          (space (make-array '#(#f) dim dim))
          (l (map string-length w)))
      (let* ((iter-space
              (rec (iter-space i j)
                   (let ((s (array-ref space i j)))
                     (if s
                         s
                         (let ((s (- M (- j i) (fold + 0 (sublist i j l)))))
                           (array-set! space s i j)
                           s)))))
             (iter-line
              (rec (iter-line i j)
                   (let ((l (array-ref line i j)))
                     (if l
                         l
                         (let ((s (iter-space i j)))
                           (cond ((negative? s)
                                  (array-set! line +inf i j))
                                 ((and (not (negative? s))
                                       (= j n))
                                  (array-set! line 0 i j))
                                 (else
                                  (array-set! line (expt s 3) i j)))
                           (array-ref line i j))))))
             (iter-cost
              (rec (iter-cost j)
                   (let ((c (array-ref cost j)))
                     (if c
                         c
                         (begin
                           (array-set! cost +inf j)
                           (cond ((negative? j)
                                  (array-set! cost 0 j)
                                  (array-set! break 0 j)) 
                                 (else (loop ((for i (up-from 0 (to j))))
                                        (let ((q (+ (iter-cost (- i 1))
                                                    (iter-line i j))))
                                          (if (< q (array-ref cost j))
                                              (begin
                                                (array-set! cost q j)
                                                (array-set! break i j)))))))
                           (array-ref cost j)))))))
        (iter-cost (- n 1))
        (values cost break)))))

(define (lines break j)
  (let* ((i (array-ref break j)))
    (if (zero? i)
        (list (cons i j))
        (append (lines break (- i 1)) (list (cons i j))))))

(define (print-lines w lines)
  (for-each
   print
   (map (lambda (bounds)
          (let ((i (car bounds))
                (j (+ (cdr bounds) 1)))
            (string-join (sublist i j w))))
        lines)))
