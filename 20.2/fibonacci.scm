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
  (p fibonacci-node-p set-fibonacci-node-parent!)
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
  (set-fibonacci-node-right! node node))

(define (root-list-append! heap node)
  (let ((min (fibonacci-heap-min heap)))
    (if min
        (splice! (fibonacci-heap-min heap) node)
        (begin
          (self-relate! node)
          (set-fibonacci-heap-min! node)))))

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
  (or (eq? (fibonacci-node-right node) node)
      (eq? (fibonacci-node-left node) node)))

(define (sever! node)
  (let ((left (fibonacci-node-left node))
        (right (fibonacci-node-right node)))
    (set-fibonacci-node-right! left right)
    (set-fibonacci-node-left! right left)))

(define (fibonacci-heap-extract-min! heap)
  (let ((min (fibonacci-heap-min heap)))
    (if min
        (let ((surrogate-min (fibonacci-node-right min)))
          (for-each
           (lambda (child)
             (root-list-append! heap child)
             (set-fibonacci-node-parent! child #f))
           (children min))
          (sever! min)
          (if (only? min)
              (set-fibonacci-heap-min! heap #f)
              (begin
                (set-fibonacci-heap-min! heap surrogate-min)
                (consolidate! heap)))
          (set-fibonacci-heap-n! (- (fibonacci-heap-n heap) 1))))
    min))
