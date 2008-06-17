(require-extension check)
(require 'section)
(import section-6.2)

(let* ((data '(27 17 3 16 13 10 1 5 7 12 4 8 9 0))
       (heap (make-heap data (length data))))
  (check (heap-data (max-heapify heap 2))
         => '(27 17 10 16 13 9 1 5 7 12 4 8 3 0)))
