(define-record-type :member
  (make-member datum representative)
  member?
  (representative member-representative set-member-representative!)
  (datum member-datum set-member-datum!))

(define (set-union! x y)
  (cond ((null? x) y)
        ((null? y) x)
        (else
         (let-values
             (((appensum appendendum)
               (if (> (length x) (length y))
                   (values x y)
                   (values y x))))
           (let ((representative
                  (member-representative (car appensum))))
             (loop ((for member (in-list appendendum)))
                   (set-member-representative! member representative))
             (set-cdr! (last-pair appensum appendendum)))))))
