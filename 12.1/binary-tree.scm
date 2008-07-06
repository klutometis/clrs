(define-record-type :bt-node
  (make-bt-node key datum left right parent)
  bt-node?
  (key bt-node-key set-bt-node-key!)
  (datum bt-node-datum set-bt-node-datum!)
  (left bt-node-left set-bt-node-left!)
  (right bt-node-right set-bt-node-right!)
  (parent bt-node-parent set-bt-node-parent!))

(define (bt-inorder-tree-map proc root)
  (let ((mapping '()))
    (let continue ((root root))
      (if root
          (begin (continue (bt-node-left root))
                 (set! mapping (cons (proc root) mapping))
                 (continue (bt-node-right root)))))
    mapping))

(define (bt-preorder-tree-map proc root)
  (let ((mapping '()))
    (let continue ((root root))
      (if root
          (begin (set! mapping (cons (proc root) mapping))
                 (continue (bt-node-left root))
                 (continue (bt-node-right root)))))
    mapping))

(define (bt-postorder-tree-map proc root)
  (let ((mapping '()))
    (let continue ((root root))
      (if root
          (begin (continue (bt-node-left root))
                 (continue (bt-node-right root))
                 (set! mapping (cons (proc root) mapping)))))
    mapping))

(define (bt-inorder-tree-map/iterative proc root)
  (let ((mapping '())
        (nodes (make-stack (make-vector 12 #f) -1)))
    (let continue ((root root))
      (if root
          (let ((left (bt-node-left root)))
            (push! nodes root)
            (continue left))
          (if (stack-empty? nodes)
              mapping
              (let ((root (pop! nodes)))
                (set! mapping (cons (proc root) mapping))
                (continue (bt-node-right root))))))))

(define (set-bt-node-left-right-parent! node left right parent)
  (set-bt-node-left! node left)
  (set-bt-node-right! node right)
  (set-bt-node-parent! node parent))

(define exercise-12.1
  (let ((n1 (make-bt-node 1 1 #f #f #f))
        (n4 (make-bt-node 4 4 #f #f #f))
        (n5 (make-bt-node 5 5 #f #f #f))
        (n10 (make-bt-node 10 10 #f #f #f))
        (n16 (make-bt-node 16 16 #f #f #f))
        (n17 (make-bt-node 17 17 #f #f #f))
        (n21 (make-bt-node 21 21 #f #f #f)))
    (set-bt-node-left-right-parent! n10 n4 n17 #f)
    (set-bt-node-left-right-parent! n4 n1 n5 n10)
    (set-bt-node-left-right-parent! n1 #f #f n4)
    (set-bt-node-left-right-parent! n5 #f #f n4)
    (set-bt-node-left-right-parent! n17 n16 n21 n10)
    (set-bt-node-left-right-parent! n16 #f #f n17)
    (set-bt-node-left-right-parent! n21 #f #f n17)
    n10))
