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

(let* ((data '(1 2 3 4))
       (heap (make-heap data (length data))))
  (check (heap-data (build-max-heap-prime heap))
         ;; was: '(4 3 1 2)!
         => '(4 3 2 1)))

(let* ((data '(1 2 3 4))
       (heap (make-heap data (length data))))
  (check (heap-data (build-max-heap heap))
         => '(4 2 3 1)))
