(require-extension syntax-case)
(require '../16.2/section)
(import section-16.2)
(let ((stations '(0 20 60 90 110 115 120 165 180))
      (full-tank 50))
  (minimize-stops stations full-tank))

;;; Let Si signify the optimal number of stops at station i. The
;;; following recurrence holds; where n is the remaining gas and N,
;;; the gas capacity:
;;;
;;; Si = (n > S{i+1} - Si) -> S{i-1}
;;;              otherwise -> S{i-1} + 1
;;; S0 = 0
;;; 
;;; If S{i-1} is not optimal, find one that is; the subproblem Si
;;; involves lazy refilling, i.e. travelling the furthest possible on
;;; the remaining gas after each stop.
