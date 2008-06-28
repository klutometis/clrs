(require-extension
 syntax-case
 check)
(require '../10.3/section)
(import section-10.3)
(let ((marray (make-marray (vector #f 4 1 #f 16 #f 9 #f)
                           (vector 5 4 1 #f 6 7 #f 3)
                           (vector #f 2 #f 7 1 0 4 5)
                           6
                           3)))
  (marray-compactify! marray)
  ;; With the exception of unzeroed keys populating the free list, a
  ;; compact representation.
  (check (marray-key marray) => '#(16 4 1 9 16 #f 9 #f))
  (check (marray-prev marray) => '#(3 0 1 #f 5 7 #f 6))
  (check (marray-next marray) => '#(1 2 #f 0 #f 4 7 5))
  (check (marray-head marray) => 3)
  (check (marray-free marray) => 6))

