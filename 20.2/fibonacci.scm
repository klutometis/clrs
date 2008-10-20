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

(define (splice! n1 n2)
  (let ((n1-left (fibonacci-node-left n1))
        (n2-left (fibonacci-node-left n2)))
    (set-fibonacci-node-right! n1-left n2-left)
    (set-fibonacci-node-left! n2-left n1-left)
    (set-fibonacci-node-right! n2 n1)
    (set-fibonacci-node-left! n1 n2)))

(define (self-relate! node)
  (set-fibonacci-node-left! node node)
  (set-fibonacci-node-right! node node)
  node)

(define (root-list-append! heap node)
  (let ((min (fibonacci-heap-min heap)))
    (if min
        (splice! (fibonacci-heap-min heap) node)
        (set-fibonacci-heap-min! heap node))))

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
  (let iter ((next (fibonacci-node-left node)))
    (if (eq? node next)
        (cons node '())
        (cons next
              (iter (fibonacci-node-left next))))))

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
        (exact-floor (log n)))))

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
       (let iter ((root root)
                  (degree (fibonacci-node-degree root)))
         (let ((byroot (vector-ref degrees degree)))
           (if byroot
               (let-values (((parent child)
                             (if (< (fibonacci-node-key root)
                                    (fibonacci-node-key byroot))
                                 (values root byroot)
                                 (values byroot root))))
                 (link! heap child parent)
                 (vector-set! degrees degree #f)
                 (iter parent (+ degree 1)))
               (vector-set! degrees degree root)))))
     (fibonacci-heap-roots heap))
    (set-fibonacci-heap-min! heap #f)
    (loop ((for root (in-vector degrees)))
          (if root
              (let ((min (fibonacci-heap-min heap)))
                (root-list-append! heap root)
                (if (or (not min)
                        (< (fibonacci-node-key root)
                           (fibonacci-node-key min)))
                    (set-fibonacci-heap-min! heap root)))))))

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
          (if (only? min)
              (set-fibonacci-heap-min! heap #f)
              (begin
                (set-fibonacci-heap-min! heap (fibonacci-node-right min))
                (consolidate! heap)))
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
