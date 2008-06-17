(define (random-search elt list)
  (let ((searched (make-list (length list) #f))
        (length-list (length list)))
    (define (next-index)
      (random-integer length-list))
    (let iter ((index (next-index)))
      (if (= (list-ref list index) elt)
          #t
          (begin
            (set-car! (drop searched index) #t)
            (if (every values searched)
                #f
                (iter (next-index))))))))
