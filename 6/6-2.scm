(require-extension check)

(require '../6/chapter)
(require '../6.2/section)
(require '../6.3/section)

(import chapter-6)
(import* section-6.2
         make-heap
         heap-data)
(import* section-6.3
         build-max-heap)

(let* ((data '(9 6 7 8 3 4 5 1 2))
       (heap (make-heap data (length data))))
  (check (heap-extract-max-dary heap 3)
         => 9)
  (check (heap-data heap)
         => '(8 6 7 2 3 4 5 1)))

(let* ((data '(9 6 7 8 3 4 5 1 2))
       (heap (make-heap data (length data))))
  (check (heap-data (max-heap-insert-dary heap 10 3))
         => '(10 9 6 7 8 3 4 5 1 2)))

(let* ((data '(9 6 7 8 3 4 5 1 2))
       (heap (make-heap data (length data))))
  (check (heap-data (heap-increase-key-dary heap 7 10 3))
         => '(10 9 6 7 8 3 4 5 2)))
