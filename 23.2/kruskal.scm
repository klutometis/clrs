(define (minimum-spanning-tree/kruskal graph)
  (let ((edges (sort (graph-edges graph) < edge-weight)))
    (loop continue ((for edge (in-list edges))
                    (with tree-edges '()))
          => tree-edges
          (let ((whence (edge-whence edge))
                (whither (edge-whither edge)))
            (let ((whence-representative
                   (set-member-representative (set-head whence)))
                  (whither-representative
                   (set-member-representative (set-head whither))))
                    (debug (list
                            (set-map set-member-datum whence)
                            (set-map set-member-datum whither)))
              (if (not (eq? whence-representative whither-representative))
                  (begin
                    (set-union! whence whither)
                    (continue
                     (=> tree-edges (cons edge tree-edges))))
                  (continue)))))))

(define (figure-23.1)
  (let ((a (make-set/datum 'a))
        (b (make-set/datum 'b))
        (c (make-set/datum 'c))
        (d (make-set/datum 'd))
        (e (make-set/datum 'e))
        (f (make-set/datum 'f))
        (g (make-set/datum 'g))
        (h (make-set/datum 'h))
        (i (make-set/datum 'i)))
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
