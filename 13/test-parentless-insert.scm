(load "red-black-tree.scm")

(use defstruct
     red-black-tree
     test
     debug)

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

;;; or is it an error to pop the parent stack past nil? it will happen
;;; when adding root, for instance.
(define stack-pop!
  (case-lambda
   ((stack)
    (stack-pop! stack
                (lambda () (error "Popping an empty stack -- stack-pop!"))))
   ((stack default)
    (if (stack-empty? stack)
        (default)
        (let ((element (stack-peek stack)))
          (stack-elements-set! stack (cdr (stack-elements stack)))
          element)))))

(define (stack-pop!/default stack default)
  (stack-pop! stack (lambda () default)))

#;(define (stack-pop! stack)
  (if (stack-empty? stack)
      (error "Popping an empty stack")
      (let ((element (stack-peek stack)))
        (stack-elements-set! stack (cdr (stack-elements stack)))
        element)))

;;; rife with parental stuff
(define (left-rotate/parents! root rotandum parents)
  (if (node-right rotandum)
      (let ((rotator (node-right rotandum)))
        (node-right-set! rotandum (node-left rotator))
        #;(if (not (node-null? (node-left rotator)))
        (node-parent-set! (node-left rotator) rotandum))
        #;(node-parent-set! rotator
        (node-parent rotandum))
        (if (stack-empty? parents)
            #;(node-null? (node-parent rotandum))
            (set! root rotator)
            (let ((parent (stack-pop!/default parents nil)))
              (if (eq? rotandum (node-left parent))
                  (node-left-set! parent rotator)
                  (node-right-set! parent rotator))
              (stack-push! parents parent)))
        (node-left-set! rotator rotandum)
        #;(node-parent-set! rotandum rotator)
        (stack-push! parents rotator)
        root)
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
        (let ((parent (stack-pop! parents nil)))
          (if (eq? rotandum (node-right parent))
              (node-right-set! parent rotator)
              (node-left-set! parent rotator))
          (stack-push! parents parent)))
    (node-right-set! rotator rotandum)
    #;(node-parent-set! rotandum rotator)
    (stack-push! parents rotator)
    root))

(trace right-rotate/parents!)
(trace left-rotate/parents!)

(define (node-parent/parents parents)
  (stack-ref parents 0 nil))

(define (node-grand-parent/parents parents)
  (stack-ref parents 1 nil))

(define node-left-uncle/parents
  (compose node-left node-grand-parent/parents))

(define node-right-uncle/parents
  (compose node-right node-grand-parent/parents))

;;; problem is, by doing this weird stack manipulation (a la
;;; defaults); we're fabricating parents, then pushing them back unto
;;; the stack. nil has a parent of nil, for instance; which isn't
;;; necessary in the explicit parent implementation. does it then
;;; climb the parent stack?
(define (insert-fixup/parents! root fixandum parents)
  ;; should we copy the parent stack to mimic referential
  ;; transparency? nah.

  ;; keeping track of fixandum is theoretically unnecessary if the
  ;; node itself has the 0th place in the parent stack.
  (let resolve-upward-until-black-parent ((fixandum fixandum))
    ;; need to pop, etc. need to discern what to push when we rotate.
    (let ((parent (stack-pop!/default parents nil))
          (grand-parent (stack-pop!/default parents nil)))
      (debug (map node-key (list fixandum parent grand-parent))
             (red? parent))
      ;; (debug (list fixandum parent grand-parent))
      (if (red? parent)
          (if (eq? parent (node-left grand-parent))
              (let ((uncle (node-right grand-parent)))
                (debug (red? uncle))
                (if (red? uncle)
                    (begin
                      (node-color-set! parent 'black)
                      (node-color-set! uncle 'black)
                      (node-color-set! grand-parent 'red)
                      (resolve-upward-until-black-parent grand-parent))
                    (begin
                      (stack-push! parents grand-parent)
                      (stack-push! parents parent)
                      (let ((fixandum (if (eq? fixandum (node-right parent))
                                          (begin
                                            (set! root
                                                  (left-rotate/parents!
                                                   root
                                                   parent
                                                   parents))
                                            parent)
                                          fixandum)))
                        (let ((parent (stack-pop!/default parents nil))
                              (grand-parent (stack-pop!/default parents nil)))
                          (node-color-set! parent 'black)
                          (node-color-set! grand-parent 'red)
                          (set! root
                                (right-rotate/parents! root
                                                       grand-parent
                                                       parents))
                          (stack-push! parents grand-parent)
                          (stack-push! parents parent)
                          (resolve-upward-until-black-parent fixandum))))))
              (let ((uncle (node-left grand-parent)))
                (if (red? uncle)
                    (begin
                      (node-color-set! parent 'black)
                      (node-color-set! uncle 'black)
                      (node-color-set! grand-parent 'red)
                      (resolve-upward-until-black-parent grand-parent))
                    (begin
                      (stack-push! parents grand-parent)
                      (stack-push! parents parent)
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
                        (let ((parent (stack-pop!/default parents nil))
                              (grand-parent (stack-pop!/default parents nil)))
                          (node-color-set! (node-parent/parents parents) 'black)
                          (node-color-set! (node-grand-parent/parents parents) 'red)
                          (set! root
                                (left-rotate/parents! root
                                                      (node-grand-parent/parents
                                                       parents)
                                                      parents))
                          (stack-push! parents grand-parent)
                          (stack-push! parents parent)
                          (resolve-upward-until-black-parent fixandum))))))))))
  (node-color-set! root 'black)
  (debug (tree->pre-order-key-color-list root))
  root)

(define (insert/parents! root inserendum)
  (let ((parents (make-stack)))
    (let-values
        (((x y)
          (let find-leaf ((x root)
                          (y nil))
            ;; this may be nil in the case of a rootless tree; do we
            ;; want to guarentee nil? we should have nil as the parent
            ;; of root.
            #;(stack-push! parents x)
            (if (node-null? x)
                (values x y)
                ;; what happens if we're dealing with sentinel whose key
                ;; is non-numeric?
                (begin
                  (stack-push! parents x)
                  (find-leaf (if (< (node-key inserendum)
                                    (node-key x))
                                 (node-left x)
                                 (node-right x))
                             x))))))
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
      #;(debug (node-key inserendum) (tree->pre-order-key-color-list root))
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
