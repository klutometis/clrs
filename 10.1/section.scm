(require-extension
 syntax-case
 foof-loop
 vector-lib
 (srfi 9 26))
(module
 section-10.1
 (make-stack
  stack-data
  push!
  pop!
  make-queue
  queue-data
  enqueue!
  dequeue!
  make-deque
  enqueue-tail!
  enqueue-head!
  dequeue-tail!
  dequeue-head!
  stack-enqueue!
  stack-dequeue!
  queue-push!
  queue-pop!)
 (include "../10.1/stack.scm")
 (include "../10.1/queue.scm")
 (include "../10.1/deque.scm")
 (include "../10.1/stack-queue.scm"))
