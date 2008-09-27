(require-extension syntax-case check)
(require '../16.2/section)
(import section-16.2)
(let ((A '(2 3 1 4 2 1 1 3 4 2 4))
      (B '(4 1 4 4 2 3 2 1 3 3 4)))
  (check (maximize-payoff A B) =>
         9393093476352))

;;; Sort A and B decreasingly (or, because of the commutativity of
;;; multiplication, increasingly); let Xi be the optimal product of
;;; a0^b0 * ... * ai^bi. Find an optimal Xi; given that:
;;;
;;;     ai > aj, bi > bj -> ai^bi > aj^bj
;;;
;;; X{i+1} is optimized by choosing the largest a{i+1}, b{i+1} in ai
;;; .. an and bi .. bn.
;;;
;;; Sort in O(n lg n), multiply in O(n) for O(n lg n).
