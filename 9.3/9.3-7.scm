(require-extension syntax-case check)
(require '../2.1/section)
(require '../9.3/section)
(import* section-2.1
         insertion-sort)
(import* section-9.3
         k-medial-proximals!)
(let ((data (vector 1 2 3 4 5)))
  (check (insertion-sort (k-medial-proximals! data 3))
         => '(2 3 4)))
