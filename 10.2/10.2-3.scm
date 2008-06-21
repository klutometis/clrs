(require-extension
 syntax-case
 check)
(require '../10.2/section)
(import section-10.2)
(let* ((sentinel (make-sentinel))
       (queue (make-slist-queue (make-slist sentinel) sentinel)))
  (slist-enqueue! queue 1)
  (slist-enqueue! queue 2)
  (slist-enqueue! queue 3)
  (check (slist-dequeue! queue) => 1))
