(define (fewest-enclosing-units points)
  (let ((points (sort points <)))
    (let ((iter
           (rec (iter units points)
                (if (null? points)
                    units
                    (let ((point (car points))
                          (rest (cdr points))
                          (end (+ (car units) 1)))
                      (if (> point end)
                          (iter (cons point units) rest)
                          (iter units rest)))))))
      (iter (list (car points)) points))))
