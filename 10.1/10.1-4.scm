(require-extension syntax-case check)
(require '../util/util)
(require '../10.1/section)
(import* section-10.1
         make-queue
         enqueue!
         dequeue!)
(import* util
         except?)
(let ((queue (make-queue (make-vector 2) 0 0)))
  (check (except? (lambda () (dequeue! queue))) => #t)
  (enqueue! queue 1)
  (check (except? (lambda () (enqueue! queue 1))) => #t))
