(require-extension check)
(require 'section)
(import section-6.3)
(require '../6.2/section)
(import* section-6.2
         make-heap
         heap-data)
(let* ((data '(5 3 17 10 84 19 6 22 9))
       (heap (make-heap data (length data))))
  (check (heap-data (build-max-heap heap))
         => '(84 22 19 10 3 17 6 5 9)))
