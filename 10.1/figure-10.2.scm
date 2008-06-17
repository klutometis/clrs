(require-extension syntax-case check)
(require '../10.1/section)
(import* section-10.1
         make-queue
         enqueue!
         queue-data)
(let ((queue (make-queue (make-vector 12 #f) 6 6)))
  (enqueue! queue 15)
  (enqueue! queue 6)
  (enqueue! queue 9)
  (enqueue! queue 8)
  (enqueue! queue 4)
  (enqueue! queue 17)
  (enqueue! queue 3)
  (enqueue! queue 5)
  (check (queue-data queue) =>
         '#(3 5 #f #f #f #f 15 6 9 8 4 17)))
