(require-extension check)
(require 'section)
(import section-6.2)

(let* ((data '(16 4 10 14 7 9 3 2 8 1))
       (heap (make-heap data (length data))))
  (check (heap-data (max-heapify heap 1))
         => '(16 14 10 8 7 9 3 2 4 1)))
