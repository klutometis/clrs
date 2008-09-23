(require-extension
 syntax-case
 array-lib
 check)
(require '../16.2/section)
(import section-16.2)
(let ((value-weights '((120 . 10)
                       (100 . 20)
                       (60 . 30)))
      (max-weight 50))
  (check (greedy-binary-knapsack value-weights max-weight) =>
         '((120 . 10) (100 . 20))))

;;; Sorting the items by increasing weight and decreasing value
;;; recreates the fractional knapsack problem: maximize the amount of
;;; the highest value density, probing the next highest until the
;;; weight has been surpassed.
;;;
;;; If Vi-1 is not optimal, optimize it: Vi = Vi-1 + vi, if wi <= w,
;;; where w is the remaining weight; Vi = Vi-1, otherwise. V0 = 0.
