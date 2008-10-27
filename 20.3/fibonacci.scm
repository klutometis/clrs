(define (fibonacci-heap-decrease-key! heap child k)
  (if (> k (fibonacci-node-key child))
      (error "Extant key larger than the key that assigneth" k)
      (let ((parent (fibonacci-node-parent child)))
        (set-fibonacci-node-key! child k)
        (if (and parent
                 (< k (fibonacci-node-key parent)))
            (begin (cut! heap child parent)
                   (cascading-cut! heap parent)))
        (if (< k (fibonacci-node-key
                  (fibonacci-heap-min heap)))
            (set-fibonacci-heap-min! heap child)))))

(define (cut! heap child parent)
  (sever! child)
  (if (only? child)
      (set-fibonacci-node-child! parent #f)
      (set-fibonacci-node-child! parent (fibonacci-node-right child)))
  (root-list-append! heap child)
  (set-fibonacci-node-degree! parent (- (fibonacci-node-degree parent) 1))
  (set-fibonacci-node-parent! child #f)
  (set-fibonacci-node-mark! child #f))

(define (cascading-cut! heap child)
  (let ((parent (fibonacci-node-parent child)))
    (if parent
        (if (fibonacci-node-mark child)
            (begin (cut! heap child parent)
                   (cascading-cut! heap parent))
            (set-fibonacci-node-mark! child #t)))))

(define (fibonacci-heap-delete! heap node)
  (fibonacci-heap-decrease-key! heap node -inf)
  (fibonacci-heap-extract-min! heap))
