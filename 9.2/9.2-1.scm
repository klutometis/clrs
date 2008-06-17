(require-extension syntax-case check)
(require '../9.2/section)
(import section-9.2)
;;; i < k -> there exists a lesser subarray, sort thereupon; i > k ->
;;; there exists a greater subarray, sort thereupon; other i = k,
;;; return A[q].
(let ((vector (vector 3 2 9 0 7 5 4 8 6 1)))
  (check (randomized-select vector 0 (- (vector-length vector) 1) 5)
         => 4))
