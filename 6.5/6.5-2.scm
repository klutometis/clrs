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
  (check (heap-data (max-heap-insert heap 10))
         => '(15 13 10 5 12 9 7 4 0 6 2 1 8)))
