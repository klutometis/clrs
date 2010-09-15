(load "red-black-tree.scm")

(use defstruct
     red-black-tree
     test)

(defstruct stack (elements '()))

(define (stack-push! stack element)
  (stack-elements-set! stack (cons element (stack-elements stack))))

(define (stack-empty? stack)
  (null? (stack-elements stack)))

(define (stack-ref stack i default)
  (let ((stack-elements (stack-elements stack)))
    (if (< i (length stack-elements))
        (list-ref stack-elements i)
        default)))

(define (stack-peek stack)
  (if (stack-empty? stack)
      (error "Peeking an empty stack")
      (car (stack-elements stack))))

(define (stack-pop! stack)
  (if (stack-empty? stack)
      (error "Popping an empty stack")
      (let ((element (stack-peek stack)))
        (stack-elements-set! stack (cdr (stack-elements stack)))
        element)))

;;; rife with parental stuff
(define (left-rotate/parents! root rotandum parents)
  (let ((rotator (node-right rotandum)))
    (node-right-set! rotandum (node-left rotator))
    #;(if (not (node-null? (node-left rotator)))
        (node-parent-set! (node-left rotator) rotandum))
    #;(node-parent-set! rotator
                      (node-parent rotandum))
    (if (stack-empty? parents)
     #;(node-null? (node-parent rotandum))
        (set! root rotator)
        (let ((parent (node-parent/parents parents)))
          (if (eq? rotandum (node-left parent))
              (node-left-set! parent rotator)
              (node-right-set! parent rotator))))
    (node-left-set! rotator rotandum)
    #;(node-parent-set! rotandum rotator)
    (stack-push! parents rotator)
    root))

(define (right-rotate/parents! root rotandum parents)
  (let ((rotator (node-left rotandum)))
    (node-left-set! rotandum (node-right rotator))
    #;(if (not (node-null? (node-right rotator)))
        (node-parent-set! (node-right rotator) rotandum))
    #;(node-parent-set! rotator
                      (node-parent rotandum))
    (if (stack-empty? parents)
        #;(node-null? (node-parent rotandum))
        (set! root rotator)
        (let ((parent (node-parent/parents parents)))
          (if (eq? rotandum (node-right parent))
              (node-right-set! parent rotator)
              (node-left-set! parent rotator))))
    (node-right-set! rotator rotandum)
    #;(node-parent-set! rotandum rotator)
    (stack-push! parents rotator)
    root))

(define (node-parent/parents parents)
  (stack-ref parents 0 nil))

(define (node-grand-parent/parents parents)
  (stack-ref parents 1 nil))

(define node-left-uncle/parents
  (compose node-left node-grand-parent/parents))

(define node-right-uncle/parents
  (compose node-right node-grand-parent/parents))

(define (insert-fixup/parents! root fixandum parents)
  ;; should we copy the parent stack to mimic referential
  ;; transparency? nah.

  ;; keeping track of fixandum is theoretically unnecessary if the
  ;; node itself has the 0th place in the parent stack.
  (let resolve-upward-until-black-parent ((fixandum fixandum))
    (let ((parent (node-parent/parents parents))
          (grand-parent (node-grand-parent/parents parents)))
      (if (red? parent)
          (if (eq? parent (node-left-uncle/parents parents))
              (let ((uncle (node-right-uncle/parents parents)))
                (if (red? uncle)
                    (begin
                      (node-color-set! parent 'black)
                      (node-color-set! uncle 'black)
                      (node-color-set! grand-parent 'red)
                      (stack-pop! parents)
                      (stack-pop! parents)
                      (resolve-upward-until-black-parent grand-parent))
                    (let ((fixandum (if (eq? fixandum (node-right parent))
                                        (begin
                                          (set! root
                                                (left-rotate/parents!
                                                 root
                                                 parent
                                                 parents))
                                          parent)
                                        fixandum)))
                      ;; have to revert to node-parent, etc. here
                      ;; because fixandum may have changed.
                      (node-color-set! (node-parent/parents parents) 'black)
                      (node-color-set! (node-grand-parent/parents parents) 'red)
                      (set! root
                            (right-rotate/parents! root
                                                   (node-grand-parent/parents
                                                    parents)
                                                   parents)))))
              (let ((uncle (node-left-uncle/parents parents)))
                (if (red? uncle)
                    (begin
                      (node-color-set! parent 'black)
                      (node-color-set! uncle 'black)
                      (node-color-set! grand-parent 'red)
                      (stack-pop! parents)
                      (stack-pop! parents)
                      (resolve-upward-until-black-parent grand-parent))
                    (let ((fixandum (if (eq? fixandum (node-left parent))
                                        (begin
                                          (set! root (right-rotate/parents!
                                                      root
                                                      parent
                                                      parents))
                                          parent)
                                        fixandum)))
                      ;; have to revert to node-parent, etc. here
                      ;; because fixandum may have changed.
                      (node-color-set! (node-parent/parents parents) 'black)
                      (node-color-set! (node-grand-parent/parents parents) 'red)
                      (set! root
                            (left-rotate/parents! root
                                                  (node-grand-parent/parents
                                                   parents)
                                                  parents)))))))))
  (node-color-set! root 'black)
  root)

(define (insert/parents! root inserendum)
  (let ((parents (make-stack)))
    (let-values
        (((x y)
          (let find-leaf ((x root)
                          (y nil))
            ;; this may be nil in the case of a rootless tree; do we
            ;; want to guarentee nil?
            (stack-push! parents x)
            (if (node-null? x)
                (values x y)
                ;; what happens if we're dealing with sentinel whose key
                ;; is non-numeric?
                (find-leaf (if (< (node-key inserendum)
                                  (node-key x))
                               (node-left x)
                               (node-right x))
                           x)))))
      #;(node-parent-set! inserendum y)
      (if (node-null? y)
          (set! root inserendum)
          (if (< (node-key inserendum)
                 (node-key y))
              (node-left-set! y inserendum)
              (node-right-set! y inserendum)))
      (node-left-set! inserendum nil)
      (node-right-set! inserendum nil)
      (node-color-set! inserendum 'red)
      (insert-fixup/parents! root inserendum parents))))

(let* ((root nil)
       (root (insert/parents! root (make-node key: 7)))
       (root (insert/parents! root (make-node key: 2)))
       (root (insert/parents! root (make-node key: 5)))
       (root (insert/parents! root (make-node key: 4)))
       (root (insert/parents! root (make-node key: 1)))
       (root (insert/parents! root (make-node key: 11)))
       (root (insert/parents! root (make-node key: 14)))
       (root (insert/parents! root (make-node key: 15)))
       (root (insert/parents! root (make-node key: 8))))
  (pp (tree->pre-order-key-color-list root))
  #;(test
   "insert/parents! with fixup"
   '((5 . black)
     ((2 . black)
      ((1 . red) (#f . black) (#f . black))
      ((4 . red) (#f . black) (#f . black)))
     ((11 . red)
      ((7 . black) (#f . black) ((8 . red) (#f . black) (#f . black)))
      ((14 . black) (#f . black) ((15 . red) (#f . black) (#f . black)))))
   (tree->pre-order-key-color-list root)))

;;; rotate is never being called!
