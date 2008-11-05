(define-record-type :set
  (make-set head tail)
  set?
  (head set-head set-set-head!)
  (tail set-tail set-set-tail!))

(define-record-type :set-member
  (make-set-member datum representative next)
  set-member?
  (datum set-member-datum)
  (representative set-member-representative set-set-member-representative!)
  (next set-member-next set-set-member-next!))

(define (set-for-each proc set)
  (let iter ((member (set-head set)))
    (if member
        (begin
          (proc member)
          (iter (set-member-next member))))))

(define (set-map proc set)
  (let iter ((member (set-head set)))
    (if (not member)
        '()
        (cons (proc member) (iter (set-member-next member))))))

(define (make-set/datum datum)
  (let* ((member (make-set-member datum #f #f))
         (set (make-set member member)))
    (set-set-member-representative! member member)
    set))

(define (set-union! x y)
  (let ((representative (set-member-representative (set-head y))))
    (set-for-each
     (lambda (member) (set-set-member-representative! member representative))
     x))
  (set-set-member-next! (set-tail y) (set-head x))
  (set-set-tail! y (set-tail x))
  (set-set-head! x (set-head y)))
