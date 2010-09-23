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
  insert/parents!
  insert-fixup!
  red?
  black?
  node?)

 (import scheme
         chicken
         data-structures)

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

 (define (red? node)
   (eq? (node-color node) 'red))

 ;; some assumptions here about the binarism of color (might be
 ;; surprised, for instance, if we have inconsistent data).
 (define (black? node)
   (not (red? node)))

 (define node-grand-parent (compose node-parent node-parent))

 (define node-left-uncle (compose node-left node-grand-parent))

 (define node-right-uncle (compose node-right node-grand-parent))

 (define (insert-fixup! root fixandum)
   (let resolve-upward-until-black-parent ((root root)
                                           (fixandum fixandum))
     (let ((parent (node-parent fixandum))
           (grand-parent (node-grand-parent fixandum)))
       (if (red? parent)
           (if (eq? parent (node-left-uncle fixandum))
               (let ((uncle (node-right-uncle fixandum)))
                 (if (red? uncle)
                     (begin
                       (node-color-set! parent 'black)
                       (node-color-set! uncle 'black)
                       (node-color-set! grand-parent 'red)
                       (resolve-upward-until-black-parent root grand-parent))
                     (let-values (((root fixandum)
                                   (if (eq? fixandum (node-right parent))
                                       (values (left-rotate! root parent) parent)
                                       (values root fixandum))))
                       ;; have to revert to node-parent, etc. here
                       ;; because fixandum may have changed.
                       (node-color-set! (node-parent fixandum) 'black)
                       (node-color-set! (node-grand-parent fixandum) 'red)
                       (resolve-upward-until-black-parent
                        (right-rotate! root (node-grand-parent fixandum))
                        fixandum))))
               (let ((uncle (node-left-uncle fixandum)))
                 (if (red? uncle)
                     (begin
                       (node-color-set! parent 'black)
                       (node-color-set! uncle 'black)
                       (node-color-set! grand-parent 'red)
                       (resolve-upward-until-black-parent grand-parent))
                     (let-values (((root fixandum)
                                   (if (eq? fixandum (node-left parent))
                                       (values (right-rotate! root parent) parent)
                                       (values root fixandum))))
                       ;; have to revert to node-parent, etc. here
                       ;; because fixandum may have changed.
                       (node-color-set! (node-parent fixandum) 'black)
                       (node-color-set! (node-grand-parent fixandum) 'red)
                       (resolve-upward-until-black-parent
                        (left-rotate! root (node-grand-parent fixandum))
                        fixandum)))))
           (begin (node-color-set! root 'black)
                  root)))))

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

 (define (tree->pre-order-key-color-list root)
   (nested-map (lambda (node) (cons (node-key node)
                                    (node-color node)))
               (tree->pre-order-list root))))
