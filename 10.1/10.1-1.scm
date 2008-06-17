(require-extension syntax-case check)
(require '../10.1/section)
(import* section-10.1
         make-stack
         stack-data
         push!
         pop!)
(let ((stack (make-stack (make-vector 6 #f) -1)))
  (push! stack 4)
  (push! stack 1)
  (push! stack 3)
  (check (pop! stack) => 3)
  (push! stack 8)
  (check (pop! stack) => 8)
  (check (stack-data stack) => '#(4 1 8 #f #f #f)))
