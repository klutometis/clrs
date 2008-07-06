(define (bt-min root)
  (let ((left (bt-node-left root)))
    (if left
        (bt-min left)
        root)))

(define (bt-max root)
  (let ((right (bt-node-right root)))
    (if right
        (bt-max right)
        root)))

(define (bt-successor root)
  (let ((right (bt-node-right root)))
    (if right
        (bt-min right)
        (let continue ((y (bt-node-parent root))
                       (x (bt-node-right (bt-node-parent root))))
          (if (and y (eq? x (bt-node-right y)))
              (continue (bt-node-parent y)
                        y)
              y)))))

(define (bt-predecessor root)
  (let ((left (bt-node-left root)))
    (if left
        (bt-max left)
        (let continue ((y (bt-node-parent root))
                       (x (bt-node-left (bt-node-parent root))))
          (if (and y (eq? x (bt-node-left y)))
              (continue (bt-node-parent y)
                        y)
              y)))))

(define figure-12.2
  (let ((n15 (make-bt-node 15 15 #f #f #f))
        (n6 (make-bt-node 6 6 #f #f #f))
        (n18 (make-bt-node 18 18 #f #f #f))
        (n3 (make-bt-node 3 3 #f #f #f))
        (n7 (make-bt-node 7 7 #f #f #f))
        (n17 (make-bt-node 17 17 #f #f #f))
        (n20 (make-bt-node 20 20 #f #f #f))
        (n2 (make-bt-node 2 2 #f #f #f))
        (n4 (make-bt-node 4 4 #f #f #f))
        (n13 (make-bt-node 13 13 #f #f #f))
        (n9 (make-bt-node 9 9 #f #f #f)))
    (set-bt-node-left-right-parent! n15 n6 n18 #f)
    (set-bt-node-left-right-parent! n6 n3 n7 n15)
    (set-bt-node-left-right-parent! n18 n17 n20 n15)
    (set-bt-node-left-right-parent! n3 n2 n4 n6)
    (set-bt-node-left-right-parent! n7 #f n13 n6)
    (set-bt-node-left-right-parent! n17 #f #f n18)
    (set-bt-node-left-right-parent! n20 #f #f n18)
    (set-bt-node-left-right-parent! n2 #f #f n3)
    (set-bt-node-left-right-parent! n4 #f #f n3)
    (set-bt-node-left-right-parent! n13 n9 #f n7)
    (set-bt-node-left-right-parent! n9 #f #f n13)
    `((n15 . ,n15)
      (n6 . ,n6)
      (n18 . ,n18)
      (n3 . ,n3)
      (n7 . ,n7)
      (n17 . ,n17)
      (n20 . ,n20)
      (n2 . ,n2)
      (n4 . ,n4)
      (n13 . ,n13)
      (n9 . ,n9))))

(define figure-12.2/root (cdr (assq 'n15 figure-12.2)))

(define figure-12.2/13 (cdr (assq 'n13 figure-12.2)))

(define figure-12.2/17 (cdr (assq 'n17 figure-12.2)))
