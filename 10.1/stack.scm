(define-record-type :stack
  (make-stack data top)
  stack?
  (data stack-data)
  (top stack-top set-stack-top!))

(define (stack-empty? stack)
  (negative? (stack-top stack)))

(define (push! stack x)
  (let ((stack-top (+ (stack-top stack) 1)))
    (set-stack-top! stack stack-top)
    (vector-set! (stack-data stack) stack-top x)))

(define (pop! stack)
  (if (stack-empty? stack)
      (error "Stack underflow -- POP")
      (let ((stack-top (- (stack-top stack) 1)))
        (set-stack-top! stack stack-top)
        (vector-ref (stack-data stack) (+ stack-top 1)))))
