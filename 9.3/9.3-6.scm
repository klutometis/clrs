(require-extension syntax-case check)
(require '../9.3/section)
(require '../2.1/section)
(import* section-2.1
         insertion-sort)
(import* section-9.3
         kth-quantiles!)
;;; http://mathforum.org/library/drmath/view/60969.html
;;; Tukey's quartiles.
(let ((data (vector 1 4 9 16 25 36 49 64 81)))
  (check (insertion-sort (kth-quantiles! data 4)) => '(9 25 49)))
