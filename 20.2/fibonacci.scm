(define-record-type :fibonacci-heap
  (make-fibonacci-heap min n)
  fibonacci-heap?
  (min fibonacci-heap-min set-fibonacci-heap-min!)
  (n fibonacci-heap-n set-fibonacci-heap-n!))

(define-record-type :fibonacci-node
  (make-fibonacci-node key datum parent child left right mark degree)
  fibonacci-node?
  (key fibonacci-node-key set-fibonacci-node-key!)
  (datum fibonacci-node-datum set-fibonacci-node-datum!)
  (p fibonacci-node-parent set-fibonacci-node-parent!)
  (child fibonacci-node-child set-fibonacci-node-child!)
  (left fibonacci-node-left set-fibonacci-node-left!)
  (right fibonacci-node-right set-fibonacci-node-right!)
  (mark fibonacci-node-mark set-fibonacci-node-mark!)
  (degree fibonacci-node-degree set-fibonacci-node-degree!))

;; (define (splice! n1 n2)
;;   (let ((n1-left (fibonacci-node-left n1))
;;         (n2-left (fibonacci-node-left n2)))
;;     (set-fibonacci-node-right! n1-left n2-left)
;;     (set-fibonacci-node-left! n2-left n1-left)
;;     (set-fibonacci-node-right! n2 n1)
;;     (set-fibonacci-node-left! n1 n2)))

(define (splice! n1 n2)
  (let ((n1-left (fibonacci-node-left n1)))
;;;     (debug (list 'splice!
;;;                  (fibonacci-node-key n1)
;;;                  (fibonacci-node-key n2)
;;;                  (fibonacci-node-key n1-left)))
    (set-fibonacci-node-right! n1-left n2)
    (set-fibonacci-node-left! n2 n1-left)
    (set-fibonacci-node-right! n2 n1)
    (set-fibonacci-node-left! n1 n2)
;;;     (debug (list 'post-splice!
;;;                  (fibonacci-node-key n1)
;;;                  (fibonacci-node-key n2)
;;;                  (fibonacci-node-key n1-left)
;;;                  (fibonacci-node-key (fibonacci-node-left n1))
;;;                  (fibonacci-node-key (fibonacci-node-right n1))
;;;                  (fibonacci-node-key (fibonacci-node-left n2))
;;;                  (fibonacci-node-key (fibonacci-node-right n2))
;;;                  (fibonacci-node-key (fibonacci-node-left n1-left))
;;;                  (fibonacci-node-key (fibonacci-node-right n1-left))))
    ))

(define (self-relate! node)
  (set-fibonacci-node-left! node node)
  (set-fibonacci-node-right! node node)
  node)

(define (root-list-append! heap node)
  (let ((min (fibonacci-heap-min heap)))
    (if min
        (splice! (fibonacci-heap-min heap) node)
        (begin
          (self-relate! node)
          (set-fibonacci-heap-min! heap node)))))

(define (fibonacci-heap-insert! heap node)
  (set-fibonacci-node-degree! node 0)
  (set-fibonacci-node-parent! node #f)
  (set-fibonacci-node-child! node #f)
  (self-relate! node)
  (set-fibonacci-node-mark! node #f)
  (let ((min (fibonacci-heap-min heap)))
    (if min
        (begin (root-list-append! heap node)
               (if (< (fibonacci-node-key node)
                      (fibonacci-node-key min))
                   (set-fibonacci-heap-min! heap node)))
        (set-fibonacci-heap-min! heap node)))
  (set-fibonacci-heap-n! heap (+ (fibonacci-heap-n heap) 1)))

(define (fibonacci-heap-union! . heaps)
  (let ((uniheap (make-fibonacci-heap #f 0)))
    (for-each (lambda (heap)
                (let ((unimin (fibonacci-heap-min uniheap))
                      (min (fibonacci-heap-min heap)))
                  (cond ((and unimin min)
                         (begin (root-list-append! uniheap min)
                                (if (< (fibonacci-node-key min)
                                       (fibonacci-node-key unimin))
                                    (set-fibonacci-heap-min! heap min))))
                        (min (set-fibonacci-heap-min! uniheap min)))))
              heaps)
    (set-fibonacci-heap-n! uniheap (apply + (map fibonacci-heap-n heaps)))
    uniheap))

(define (siblings node)
;;;   (debug (fibonacci-node-key node))
  (cons node
        (let iter ((next (fibonacci-node-right node)))
;;;     (debug (fibonacci-node-key next))
          (if (eq? node next)
              '()
              (cons next
                    (iter (fibonacci-node-right next)))))))

(define (fibonacci-heap-roots heap)
  (let ((min (fibonacci-heap-min heap)))
    (if min
        (siblings min)
        '())))

(define (children node)
  (let ((child (fibonacci-node-child node)))
    (if child
        (siblings child)
        '())))

(define (only? node)
  (and (eq? (fibonacci-node-right node) node)
       (eq? (fibonacci-node-left node) node)))

(define (sever! node)
  (let ((left (fibonacci-node-left node))
        (right (fibonacci-node-right node)))
    (set-fibonacci-node-right! left right)
    (set-fibonacci-node-left! right left)))

(define (maximum-degree heap)
  (let ((n (fibonacci-heap-n heap)))
    (if (zero? n)
        0
        (exact-floor (/ (log n) (log 2))))))

(define (link! heap child parent)
  (sever! child)
  (let ((sibling (fibonacci-node-child parent)))
    (if sibling
        (splice! sibling child)
        (begin
          (self-relate! child)
          (set-fibonacci-node-child! parent child)))
    (set-fibonacci-node-parent! child parent)
    (set-fibonacci-node-degree! parent (+ (fibonacci-node-degree parent) 1))
    (set-fibonacci-node-mark! child #f)))

(define (consolidate! heap)
  (let ((degrees (make-vector (+ (maximum-degree heap) 1) #f)))
    (for-each
     (lambda (root)
;;;        (debug (list 'for-each
;;;                     (fibonacci-node-key root)))
       (let iter ((root root)
                  (degree (fibonacci-node-degree root)))
;;;          (debug (list
;;;                  'iter
;;;                  (fibonacci-node-key root)
;;;                  degree))
         (let ((byroot (vector-ref degrees degree)))
;;;            (debug (list 'byroot
;;;                         (if byroot
;;;                             (fibonacci-node-key byroot)
;;;                             #f)))
           (if byroot
               (let-values (((parent child)
                             (if (< (fibonacci-node-key root)
                                    (fibonacci-node-key byroot))
                                 (values root byroot)
                                 (values byroot root))))
;;;                  (debug (list
;;;                          'link
;;;                          (fibonacci-node-key child)
;;;                          (fibonacci-node-key parent)))
                 (link! heap child parent)
;;;                  (debug (fibonacci-heap->list fibonacci-node-key heap))
                 (vector-set! degrees degree #f)
                 (iter parent (+ degree 1)))
               (vector-set! degrees degree root)))))
     (fibonacci-heap-roots heap))
    (set-fibonacci-heap-min! heap #f)
;;;     (debug (vector-map (lambda (i x) (if x (fibonacci-node-key x) #f)) degrees))
    (loop ((for root (in-vector degrees)))
          (if root
              (let ((min (fibonacci-heap-min heap)))
                (root-list-append! heap root)
                (if (or (not min)
                        (< (fibonacci-node-key root)
                           (fibonacci-node-key min)))
                    (set-fibonacci-heap-min! heap root))))
;;;           (debug (fibonacci-heap->list fibonacci-node-key heap))
          )))

(define (fibonacci-heap-extract-min! heap)
  (let ((min (fibonacci-heap-min heap)))
    (if min
        (begin
          (for-each
           (lambda (child)
             (root-list-append! heap child)
             (set-fibonacci-node-parent! child #f))
           (children min))
          (set-fibonacci-node-child! min #f)
          (sever! min)
;;;           (debug (map fibonacci-node-key (siblings (fibonacci-node-right (fibonacci-node-right min)))))
          (if (only? min)
              (set-fibonacci-heap-min! heap #f)
              (begin
                (set-fibonacci-heap-min! heap (fibonacci-node-right min))
;;;                 (debug (fibonacci-heap->list fibonacci-node-key heap))
                (consolidate! heap)
;;;                 (debug (fibonacci-heap->list fibonacci-node-key heap))
                ))
          (set-fibonacci-heap-n! heap (- (fibonacci-heap-n heap) 1))
          ))
    min))

(define (fibonacci-heap->list proc heap)
  (let iter ((root (fibonacci-heap-min heap)))
    (if root
        (let ((siblings (siblings root)))
          (map (lambda (sibling)
                 (cons (proc sibling)
                       (iter (fibonacci-node-child sibling))))
               siblings))
        '())))

(define (set-fibonacci-node-parent-child-left-right!
         node
         parent
         child
         left
         right)
  (set-fibonacci-node-parent! node parent)
  (set-fibonacci-node-child! node child)
  (set-fibonacci-node-left! node left)
  (set-fibonacci-node-right! node right))

(define (figure-20.3)
  (let ((heap (make-fibonacci-heap #f 15))
        (n23 (make-fibonacci-node 23 #f #f #f #f #f #f 0))
        (n7 (make-fibonacci-node 7 #f #f #f #f #f #f 0))
        (n21 (make-fibonacci-node 21 #f #f #f #f #f #f 0))
        (n3 (make-fibonacci-node 3 #f #f #f #f #f #f 3))
        (n17 (make-fibonacci-node 17 #f #f #f #f #f #f 1))
        (n24 (make-fibonacci-node 24 #f #f #f #f #f #f 2))
        (n18 (make-fibonacci-node 18 #f #f #f #f #f #f 1))
        (n52 (make-fibonacci-node 52 #f #f #f #f #f #f 0))
        (n38 (make-fibonacci-node 38 #f #f #f #f #f #f 1))
        (n30 (make-fibonacci-node 30 #f #f #f #f #f #f 0))
        (n26 (make-fibonacci-node 26 #f #f #f #f #f #f 1))
        (n46 (make-fibonacci-node 46 #f #f #f #f #f #f 0))
        (n39 (make-fibonacci-node 39 #f #f #f #f #f #f 0))
        (n41 (make-fibonacci-node 41 #f #f #f #f #f #f 0))
        (n35 (make-fibonacci-node 35 #f #f #f #f #f #f 0)))
    (set-fibonacci-node-parent-child-left-right! n23 #f #f n24 n7)
    (set-fibonacci-node-parent-child-left-right! n7 #f #f n23 n21)
    (set-fibonacci-node-parent-child-left-right! n21 #f #f n7 n3)
    (set-fibonacci-node-parent-child-left-right! n3 #f n18 n21 n17)
    (set-fibonacci-node-parent-child-left-right! n17 #f n30 n3 n24)
    (set-fibonacci-node-parent-child-left-right! n24 #f n26 n17 n23)
    (set-fibonacci-node-parent-child-left-right! n18 n3 n39 n38 n52)
    (set-fibonacci-node-parent-child-left-right! n52 n3 #f n18 n38)
    (set-fibonacci-node-parent-child-left-right! n38 n3 n41 n52 n18)
    (set-fibonacci-node-parent-child-left-right! n30 n17 #f n30 n30)
    (set-fibonacci-node-parent-child-left-right! n26 n24 n35 n46 n46)
    (set-fibonacci-node-parent-child-left-right! n46 n24 #f n26 n26)
    (set-fibonacci-node-parent-child-left-right! n39 n18 #f n39 n39)
    (set-fibonacci-node-parent-child-left-right! n41 n38 #f n41 n41)
    (set-fibonacci-node-parent-child-left-right! n35 n26 #f n35 n35)
    (set-fibonacci-heap-min! heap n3)
    heap))
