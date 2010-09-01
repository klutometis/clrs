(use defstruct debug test)

;;; common-enough name; maybe importers can import it as
;;; red-black-node, if need be?
(defstruct node color key left right parent)

;;; it turns out that the parent, etc. of nil may well be set during
;;; algos; pathological?
(define nil (make-node color: 'black
                       key: #f
                       left: #f
                       right: #f
                       parent: #f))

(define (node-null? node)
  (eq? node nil))

;;; have these things return the new root?
(define (left-rotate! root rotandum)
  (let ((rotator (node-right rotandum)))
    (node-right-set! rotandum (node-left rotator))
    (if (not (node-null? (node-left rotator)))
        (node-parent-set! (node-left rotator) rotandum))
    (node-parent-set! rotator
                      (node-parent rotandum))
    (if (node-null? (node-parent rotandum))
        (set! root rotator)
        (if (eq? rotandum (node-left (node-parent rotandum)))
            (node-left-set! (node-parent rotandum) rotator)
            (node-right-set! (node-parent rotandum) rotator)))
    (node-left-set! rotator rotandum)
    (node-parent-set! rotandum rotator)
    root))

(define (right-rotate! root rotandum)
  (let ((rotator (node-left rotandum)))
    (node-left-set! rotandum (node-right rotator))
    (if (not (node-null? (node-right rotator)))
        (node-parent-set! (node-right rotator) rotandum))
    (node-parent-set! rotator
                      (node-parent rotandum))
    (if (node-null? (node-parent rotandum))
        (set! root rotator)
        (if (eq? rotandum (node-right (node-parent rotandum)))
            (node-right-set! (node-parent rotandum) rotator)
            (node-left-set! (node-parent rotandum) rotator)))
    (node-right-set! rotator rotandum)
    (node-parent-set! rotandum rotator)
    root))

(define (tree->pre-order-list node)
  (if (and (node? node) (not (node-null? node)))
      (list node
            ;; could refrain from doing these in the case of nil, or
            ;; even adjust the LIST above.
            (tree->pre-order-list (node-left node))
            (tree->pre-order-list (node-right node)))
      nil))

;; (trace tree->pre-order-list)

(define (nested-map f tree)
  (if (pair? tree)
      (map (cut nested-map f <>) tree)
      (f tree)))

(define (tree->pre-order-key-list root)
  (nested-map node-key (tree->pre-order-list root)))

(let ((node-38 (make-node color: 'black
                          key: 38
                          parent: nil))
      (node-21 (make-node color: 'red
                          key: 21
                          left: nil
                          right: nil))
      (node-41 (make-node color: 'black
                          key: 41
                          left: nil
                          right: nil))
      (node-51 (make-node color: 'black
                          key: 51
                          left: nil
                          right: nil))
      (node-39 (make-node color: 'black
                          key: 39
                          left: nil
                          right: nil))
      (pre-order-tree '(38 (21 #f #f) (41 (39 #f #f) (51 #f #f))))
      (left-rotated-pre-order-tree '(41 (38 (21 #f #f) (39 #f #f)) (51 #f #f))))
  (node-left-set! node-38 node-21)
  (node-right-set! node-38 node-41)
  (node-left-set! node-41 node-39)
  (node-right-set! node-41 node-51)
  (node-parent-set! node-21 node-38)
  (node-parent-set! node-41 node-38)
  (node-parent-set! node-39 node-41)
  (node-parent-set! node-51 node-41)
  (test
   "tree structure"
   pre-order-tree
   (tree->pre-order-key-list node-38))
  (let ((left-rotated-root (left-rotate! node-38 node-38)))
    (test
     "left rotation"
     left-rotated-pre-order-tree
     (tree->pre-order-key-list left-rotated-root))
    (let ((right-rotated-root (right-rotate! left-rotated-root left-rotated-root)))
      (test
       "right rotation inverse of left rotation"
       pre-order-tree
       (tree->pre-order-key-list right-rotated-root)))))
