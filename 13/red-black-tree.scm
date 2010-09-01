(module
 red-black-tree

 (make-node
  nil
  node-color-set!
  node-left-set!
  node-right-set!
  node-parent-set!
  left-rotate!
  right-rotate!
  node-null?
  node-color
  node-key
  node-left
  node-right
  node-parent
  node->alist
  nested-map
  tree->pre-order-list
  tree->pre-order-key-list
  tree->pre-order-key-color-list
  insert!
  insert-fixup!)

 (import scheme
         chicken)

 (use defstruct)

 ;; common-enough name; maybe importers can import it as
 ;; red-black-node, if need be?
 (defstruct node color key left right parent)

 ;; it turns out that the parent, etc. of nil may well be set during
 ;; algos; pathological?
 (define nil (make-node color: 'black
                        key: #f
                        left: #f
                        right: #f
                        parent: #f))

 (define (node-null? node)
   (eq? node nil))

 ;; have these things return the new root?
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

 ;; NOOP
 (define (insert-fixup! root fixandum) root)

 (define (insert! root inserendum)
  (let-values
      (((x y)
        (let find-leaf ((x root)
                        (y nil))
          (if (node-null? x)
              (values x y)
              ;; what happens if we're dealing with sentinel whose key
              ;; is non-numeric?
              (find-leaf (if (< (node-key inserendum)
                                (node-key x))
                             (node-left x)
                             (node-right x))
                         x)))))
    (node-parent-set! inserendum y)
    (if (node-null? y)
        (set! root inserendum)
        (if (< (node-key inserendum)
               (node-key y))
            (node-left-set! y inserendum)
            (node-right-set! y inserendum)))
    (node-left-set! inserendum nil)
    (node-right-set! inserendum nil)
    (node-color-set! inserendum 'red)
    (insert-fixup! root inserendum)))

 (define (tree->pre-order-key-color-list root)
   (nested-map (lambda (node) (cons (node-key node)
                                    (node-color node)))
               (tree->pre-order-list root))))
