(require-extension syntax-case
                   check)
(require 'section)
(import section-6.5)
(require '../6.2/section)
(import* section-6.2
         make-heap
         heap-data)

(let* ((data '(15 13 9 5 12 8 7 4 0 6 2 1))
       (heap (make-heap data (length data))))
  (check (heap-extract-max heap)
         => 15)
  (check (heap-data heap)
         => '(13 12 9 5 6 8 7 4 0 1 2)))
