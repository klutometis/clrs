(require-extension syntax-case check)
(require '../10.1/section)
(import* section-10.1
         make-queue
         enqueue!
         dequeue!
         queue-data)
(let ((queue (make-queue (make-vector 6 #f) 0 0)))
  (enqueue! queue 4)
  (enqueue! queue 1)
  (enqueue! queue 3)
  (check (dequeue! queue) => 4)
  (enqueue! queue 8)
  (check (dequeue! queue) => 1)
  (check (queue-data queue) => '#(4 1 3 8 #f #f)))
