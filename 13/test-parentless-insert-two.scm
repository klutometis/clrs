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

;;; rife with parental stuff
(define (left-rotate/parent! root rotandum parent)
  (let ((rotator (node-right rotandum)))
    (node-right-set! rotandum (node-left rotator))
    (if (node-null? parent)
        (set! root rotator)
        (if (eq? rotandum (node-left parent))
            (node-left-set! parent rotator)
            (node-right-set! parent rotator)))
    (node-left-set! rotator rotandum)
    (values root rotator)))

(define (right-rotate/parent! root rotandum parent)
  (let ((rotator (node-left rotandum)))
    (node-left-set! rotandum (node-right rotator))
    (if (node-null? parent)
        (set! root rotator)
        (if (eq? rotandum (node-right parent))
            (node-right-set! parent rotator)
            (node-left-set! parent rotator)))
    (node-right-set! rotator rotandum)
    (values root rotator)))

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
  (let resolve-upward-until-black-parent ((root root)
                                          (fixandum fixandum))
    ;; need to pop, etc. need to discern what to push when we rotate.
    (let ((parent (stack-pop! parents)))
      (if (red? parent)
          (let ((grand-parent (stack-pop! parents)))
            (if (eq? parent (node-left grand-parent))
                (let ((uncle (node-right grand-parent)))
                  (if (red? uncle)
                      (begin
                        (node-color-set! parent 'black)
                        (node-color-set! uncle 'black)
                        (node-color-set! grand-parent 'red)
                        (resolve-upward-until-black-parent root grand-parent))
                      (let-values (((root fixandum parent)
                                    (if (eq? fixandum (node-right parent))
                                        (let-values (((new-root new-parent)
                                                      (left-rotate/parent!
                                                       root
                                                       parent
                                                       grand-parent))) 
                                          (values new-root parent new-parent))
                                        (values root fixandum parent))))
                        (node-color-set! parent 'black)
                        (node-color-set! grand-parent 'red)
                        (let ((great-grand-parent (stack-pop! parents)))
                          (let-values (((new-root new-parent)
                                        (right-rotate/parent! root
                                                              grand-parent
                                                              great-grand-parent)))
                            (stack-push! parents great-grand-parent)
                            (stack-push! parents new-parent)
                            (resolve-upward-until-black-parent new-root fixandum))))))
                (let ((uncle (node-left grand-parent)))
                  (if (red? uncle)
                      (begin
                        (node-color-set! parent 'black)
                        (node-color-set! uncle 'black)
                        (node-color-set! grand-parent 'red)
                        (resolve-upward-until-black-parent root grand-parent))
                      (let-values (((root fixandum parent)
                                    (if (eq? fixandum (node-left parent))
                                        (let-values (((new-root new-parent)
                                                      (right-rotate/parent!
                                                       root
                                                       parent
                                                       grand-parent))) 
                                          (values new-root parent new-parent))
                                        (values root fixandum parent))))
                        (node-color-set! parent 'black)
                        (node-color-set! grand-parent 'red)
                        (let ((great-grand-parent (stack-pop! parents)))
                          (let-values (((new-root new-parent)
                                        (left-rotate/parent! root
                                                              grand-parent
                                                              great-grand-parent)))
                            (stack-push! parents great-grand-parent)
                            (stack-push! parents new-parent)
                            (resolve-upward-until-black-parent new-root fixandum))))))))
          (begin (node-color-set! root 'black)
                 root)))))

(define (insert/parents! root inserendum)
  (let ((parents (make-stack)))
    (let-values
        (((x y)
          (let find-leaf ((x root)
                          (y nil))
            ;; this may be nil in the case of a rootless tree; do we
            ;; want to guarentee nil? we should have nil as the parent
            ;; of root.
            (stack-push! parents y)
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
       (root (insert/parents! root (make-node key: 8)))
       )
  (test
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
