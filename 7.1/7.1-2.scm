(require-extension
 syntax-case
 check)
(require '../7.1/section)
(import* section-7.1
         partition-increasing!)

;;; Answer here; floor((p + r) / 2) pathologizes.
(let ((vector '#(2 2 2 2 2)))
  (check (partition-increasing! vector 0 (- (vector-length vector) 1))
         => 4))
