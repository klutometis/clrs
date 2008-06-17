(require-extension syntax-case check)
(require '../9.2/section)
(import section-9.2)
;;; Iteration (of sorts); with tail-call optimization, is
;;; iterative/recursive really a useful distinction?
(let ((vector (vector 3 2 9 0 7 5 4 8 6 1)))
  (randomized-select-iter vector 0 (- (vector-length vector) 1) 5))
