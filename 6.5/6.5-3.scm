(require-extension syntax-case
                   check)
(require 'section)
(import section-6.5)
(require '../6.2/section)
(import* section-6.2
         make-heap
         heap-data)
(require '../6.3/section)
(import* section-6.3
         build-min-heap)

(let* ((data '(15 13 9 5 12 8 7 4 0 6 2 1))
       (heap (build-min-heap (make-heap data (length data)))))
  (check (heap-data (min-heap-insert heap 10))
         => '(0 2 1 4 6 8 7 13 5 15 12 9 10)))
