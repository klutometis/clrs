(define (binary-knapsack value-weights max-weight)
  (let* ((n (length value-weights))
         (weights (make-array '#(#f) `(-1 ,n) `(-1 ,(+ max-weight 1)))))
    (let ((iter-weight
           (rec (iter-weight index weight)
                (let ((w (array-ref weights index weight)))
                  (if w
                      w
                      (begin
                        (if (or (negative? index)
                                (negative? weight))
                            (array-set! weights 0 index weight)
                            (let ((value-weight (list-ref value-weights index)))
                              (let ((vi (car value-weight))
                                    (wi (cdr value-weight)))
                                (if (> wi weight)
                                    (array-set! weights
                                                (iter-weight (- index 1) weight)
                                                index
                                                weight)
                                    (array-set! weights
                                                (max
                                                 (+ vi
                                                    (iter-weight (- index 1)
                                                                 (- weight wi)))
                                                 (iter-weight (- index 1) weight))
                                                index
                                                weight)))))
                        (array-ref weights index weight)))))))
      (iter-weight (- n 1) max-weight)
      weights)))

(define (weights->items weights items max-weight)
  (let ((n (length items)))
    (let ((iter-item
           (rec (iter-item index weight)
                (if (or (negative? index)
                        (negative? weight))
                    '()
                    (let ((vi (array-ref weights index weight))
                          (vi-1 (array-ref weights (- index 1) weight)))
                      (if (= vi vi-1)
                          (iter-item (- index 1) weight)
                          (cons index (iter-item
                                       (- index 1)
                                       (- weight
                                          (cdr (list-ref items index)))))))))))
      (iter-item (- n 1) max-weight))))

(define (greedy-binary-knapsack value-weights max-weight)
  (let ((rest (find-tail
               (lambda (value-weight)
                 (let ((value (car value-weight))
                       (weight (cdr value-weight)))
                   (< weight max-weight)))
               value-weights)))
    (if rest
        (let ((value-weight (car rest)))
          (let ((value (car value-weight))
                (weight (cdr value-weight)))
            (cons value-weight
                  (greedy-binary-knapsack (cdr rest)
                                          (- max-weight weight)))))
        '())))
