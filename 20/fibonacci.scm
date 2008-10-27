(define (fibonacci-heap-change-key! heap node k)
  (let ((key (fibonacci-node-key node)))
    (cond ((= k key))
          ((< k key) (fibonacci-heap-decrease-key! heap node k))
          (else
           (let ((children (children node)))
             (for-each (cut cut! heap <> node) children)
             (set-fibonacci-node-key! node k)
             (let ((parent (fibonacci-node-parent node)))
               (if parent
                   (begin
                     (cut! heap node parent)
                     (cascading-cut! heap parent)))))))))
