(require-extension
 syntax-case
 check)
(require '../9.3/section)
(import section-9.3)
(let ((data (vector 3 2 9 0 7 5 4 8 6 1)))
  (check (select! data 0 (- (vector-length data) 1) 5)
         => 4))
