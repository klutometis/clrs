

(define (bit-string->list bit-string)
  (map (lambda (bit) (eq? bit #\1)) (string->list bit-string)))

(define (next-node node bit)
  (if bit
      (bt-node-right node)
      (bt-node-left node)))

(define (rt-preorder-tree-map proc root)
  (let ((mapping '()))
    (let continue ((root root))
      (if root
          (begin (if (bt-node-key root)
                     (set! mapping (cons (proc root) mapping)))
                 (continue (bt-node-left root))
                 (continue (bt-node-right root)))))
    mapping))

(define (rt-insert! root bit-string)
  (let ((bits (bit-string->list bit-string)))
    (loop continue ((for bit bits (in-list bits))
                    (with parent root))
          (let* ((next-node (next-node parent bit))
                 (node (if next-node
                           next-node
                           (make-bt-node #f '*bridge* #f #f parent))))
            (if (not (eq? next-node node))
                (if bit
                    (set-bt-node-right! parent node)
                    (set-bt-node-left! parent node)))
            (if (null? (cdr bits))
                (begin
                  (set-bt-node-key! node #t)
                  (set-bt-node-datum! node bit-string)))
;;;             (format #t "~A~%" (bt-node-datum node))
            (continue (=> parent node))))))

(define (figure-12.5)
  (let ((n (make-bt-node #f "*root*" #f #f #f))
        (n0 (make-bt-node #t "0" #f #f #f))
        (n01 (make-bt-node #f "01" #f #f #f))
        (n011 (make-bt-node #t "011" #f #f #f))
        (n1 (make-bt-node #f "1" #f #f #f))
        (n10 (make-bt-node #t "10" #f #f #f))
        (n100 (make-bt-node #t "100" #f #f #f))
        (n101 (make-bt-node #f "101" #f #f #f))
        (n1011 (make-bt-node #t "1011" #f #f #f)))
    (set-bt-node-left-right-parent! n n0 n1 #f)
    (set-bt-node-left-right-parent! n0 #f n01 n)
    (set-bt-node-left-right-parent! n1 n10 #f n)
    (set-bt-node-left-right-parent! n01 #f n011 n0)
    (set-bt-node-left-right-parent! n10 n100 n101 n1)
    (set-bt-node-left-right-parent! n011 #f #f n01)
    (set-bt-node-left-right-parent! n100 #f #f n10)
    (set-bt-node-left-right-parent! n101 #f n1011 n10)
    (set-bt-node-left-right-parent! n1011 #f #f n101)
    n))
