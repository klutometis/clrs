(require-extension syntax-case check)
(require '../16.2/section)
(import section-16.2)
(let ((points '(4.3200999001462 3.24014669888432 1.67223498686796
                                6.02249733095044 1.27659957146568
                                5.51236296877533 6.25987637556491
                                1.66015679233536 0.922929342828995
                                6.33755434076565 0.110906341827595
                                2.67594372588124 6.52964063877362
                                5.87378888338527 2.30117077907629
                                6.85922030050257)))
  (check (fewest-enclosing-units points) =>
         '(6.52964063877362 5.51236296877533 4.3200999001462
                            2.30117077907629 1.27659957146568
                            0.110906341827595)))

;;; Greedy algorithm starting from X', the sorted set of points in
;;; X. Say there are n points in X', the first k of which are enclosed
;;; in u0 in U, the set of enclosing units. Let Sk express the optimum
;;; number of units for the first k points. If Sk is not optimal,
;;; choose one that is; the subproblem reduces to finding S{n-k}
;;; .. Sn.
;;; 
;;; Si = {   xi > uk + 1 -> S{i-1} + 1, k = k + 1, uk = xi
;;;      {     otherwise -> S{i-1}
;;; 
;;; A unit, uk, is chosen whose beginning is coincident with the first
;;; point in the subproblem, xi; one iterates through the points until
;;; xj > uk; then U = U + uk, u{k+1} = xj; k = k + 1. Repeat until all
;;; points have been accounted for. U is a minimal list of units.
