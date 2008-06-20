(require-extension syntax-case check)
(require '../10.1/section)
(import* section-10.1
         stack-enqueue!
         stack-dequeue!
         stack-data
         make-stack)
;;; stack-enqueue! is Theta(2n), where n is the length of the queue;
;;; while stack-dequeue! is Theta(3n) because of the extra
;;; vector-fill!
(let ((stack (make-stack (make-vector 6 #f) -1)))
  (stack-enqueue! stack 4)
  (stack-enqueue! stack 1)
  (stack-enqueue! stack 3)
  (check (stack-dequeue! stack) => 4)
  (stack-enqueue! stack 8)
  (check (stack-dequeue! stack) => 1)
  (check (stack-data stack) => '#(3 8 #f #f #f #f)))
