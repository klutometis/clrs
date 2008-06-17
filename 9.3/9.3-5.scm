(require-extension
 syntax-case
 check)
(require '../9.3/section)
(import* section-9.3 balanced-select!)
;;; Partitions the space optimally into n/2 subproblems (see 9.3-3);
;;; assuming that partition-median! runs Theta(n) (isn't it actually
;;; Theta(n^2) worst-case, since it employs randomized-select?), T(n)
;;; <= T(n/2) + O(n) epsilon Theta(n).
(let ((data (vector 3 2 9 0 7 5 4 8 6 1)))
  (check (balanced-select! data 0 (- (vector-length data) 1) 5)
         => 4))
