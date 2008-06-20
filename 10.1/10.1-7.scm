(require-extension syntax-case check)
(require '../10.1/section)
(import* section-10.1
         make-queue
         queue-data
         queue-push!
         queue-pop!)
;;; queue-push! is Theta(2n), where n is the length of the stack;
;;; while queue-pop! is Theta(3n) because of the extra vector-fill!
(let ((queue (make-queue (make-vector 6 #f) 0 0)))
  (queue-push! queue 4)
  (queue-push! queue 1)
  (queue-push! queue 3)
  (check (queue-pop! queue) => 3)
  (queue-push! queue 8)
  (check (queue-pop! queue) => 8)
  (check (queue-data queue) => '#(4 #f #f #f #f 1)))
