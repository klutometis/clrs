(require-extension syntax-case check)
(require '../10.1/section)
(import* section-10.1
         make-deque
         enqueue-head!
         enqueue-tail!
         dequeue-head!
         dequeue-tail!
         queue-data)
(let ((queue (make-deque (make-vector 6 #f) 0 0)))
  (enqueue-tail! queue 4)
  (enqueue-tail! queue 1)
  (enqueue-head! queue 3)
  (check (dequeue-tail! queue) => 1)
  (enqueue-tail! queue 8)
  (check (dequeue-head! queue) => 3)
  (check (queue-data queue) => '#(8 1 #f #f #f 3)))
