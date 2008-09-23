(require-extension
 syntax-case
 array-lib
 check)
(require '../16.2/section)
(import section-16.2)
(let ((value-weights '((60 . 10)
                       (100 . 20)
                       (120 . 30)))
      (max-weight 50))
  (check (weights->items
          (binary-knapsack value-weights 50) value-weights max-weight) =>
          '(2 1)))

;;; Recurrence:
;;; 
;;; Wi,w = { i = 0 or j = 0 -> 0
;;;        { otherwise, max(vi + Wi-1,w-wi, Wi-1,w)
;;;
;;; where Wi,w is the optimal value of items 1 .. i at weight w.
;;;
;;; Wi-1,w-wi is an optimal solution, otherwise substitute an optimal
;;; solution; Wi,w is therefore Wi-1,w-wi + vi.
