(define (return continuation)
  (display 'jewsus)
  (continuation ))

(define i 0)

(define continuation)

(call-with-current-continuation
 (lambda (return)
   (let loop ()
     (display 'niggars)
     (set! i (+ i 1))
     (display i)
     (if (< i 10)
         (loop)
         (begin
           (set! continuation return)
           (display i)
           (return 'jewsus))))))

(continuation 'ouentheuotnh)
