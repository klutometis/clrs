(define (randomize-in-place urlist)
  (let iter ((list urlist))
    (if (null? list)
        urlist
        (let ((swap-with (random-integer (length list))))
          (swap-first! list swap-with)
          (iter (cdr list))))))

(define (randomize-in-place-marceau urlist)
  (if (null? urlist)
      urlist
      (let ((initial-swap (random-integer (length urlist))))
        (swap-first! urlist initial-swap)
        (let iter ((list (cdr urlist)))
          (if (null? list)
              urlist
              (randomize-in-place list)))
        (values))))

(define (randomize-in-place-kelp urlist)
  (let iter ((list urlist))
    (if (null? list)
        urlist
        (if (= (length list) 1)
            urlist
            (let ((swap-with (+ (random-integer (- (length list) 1)) 1)))
              (swap-first! list swap-with)
              (iter (cdr list)))))))

(define (randomize-in-place-cyclic urlist)
  (let ((length-urlist (length urlist)))
    (let ((destination (make-list length-urlist #f))
          (offset (random-integer length-urlist)))
      (let iter ((list urlist)
                 (index 0))
        (if (null? list)
            destination
            (let ((destination-ref (modulo (+ index offset) length-urlist)))
              (set-car! (drop destination destination-ref)
                        (car list))
              (iter (cdr list) (+ index 1))))))))
