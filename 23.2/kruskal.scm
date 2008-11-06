(define (minimum-spanning-tree/kruskal graph)
  (let ((edges (sort (graph-edges graph) < edge-weight)))
    (loop continue ((for edge (in-list edges))
                    (with tree-edges '()))
          => tree-edges
          (let ((whence (edge-whence edge))
                (whither (edge-whither edge)))
            (let ((whence-set (node-datum whence))
                  (whither-set (node-datum whither))
                  (whence-label (node-label whence))
                  (whither-label (node-label whither)))
              (let ((whence-representative
                     (set-member-representative
                      (set-head whence-set)))
                    (whither-representative
                     (set-member-representative
                      (set-head whither-set))))
                (if (not (eq? whence-representative whither-representative))
                    (begin
                      (debug (list
                              whence-label
                              whither-label
                              (set-map set-member-datum whence-set)
                              (set-map set-member-datum whither-set)))
                      (set-union! whence-set whither-set)
                      (continue
                       (=> tree-edges
                           (cons (cons whence-label whither-label) tree-edges))))
                    (continue))))))))

(define (figure-23.1)
  (let ((a (make-node (make-set/datum 'a) 'a 0))
        (b (make-node (make-set/datum 'b) 'b 0))
        (c (make-node (make-set/datum 'c) 'c 0))
        (d (make-node (make-set/datum 'd) 'd 0))
        (e (make-node (make-set/datum 'e) 'e 0))
        (f (make-node (make-set/datum 'f) 'f 0))
        (g (make-node (make-set/datum 'g) 'g 0))
        (h (make-node (make-set/datum 'h) 'h 0))
        (i (make-node (make-set/datum 'i) 'i 0)))
    (let ((adjacencies
           (list->adjacencies
            `((,a ,b)
              (,b ,c ,h)
              (,c ,d ,f)
              (,d ,e)
              (,e ,f)
              (,f ,d ,g)
              (,g ,h)
              (,h ,a ,i)
              (,i ,c ,g))))
          (weight-ref
           (bidirectional-weight-ref
            `((,a ,b 4)
              (,b ,c 8)
              (,c ,d 7)
              (,d ,e 9)
              (,e ,f 10)
              (,f ,g 2)
              (,g ,h 1)
              (,h ,a 8)
              (,b ,h 11)
              (,h ,i 7)
              (,i ,c 2)
              (,i ,g 6)
              (,c ,f 4)
              (,f ,d 14)))))
      (make-weighted-graph adjacencies weight-ref))))
