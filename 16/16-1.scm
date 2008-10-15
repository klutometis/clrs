(require-extension syntax-case check)
(require '../16/chapter)
(import chapter-16)
;;; In making change for n cents, there is an optimal solution
;;; involving a coin with c cents; there are no less than k - 1 coins
;;; in an optimal solution for the n - c subproblem, or else we could
;;; have specified k - 1 coins: contradicting the optimality
;;; assumption. The problem, therefore, has optimal substructure.

;;; a. With floor(n/25) quarters, we are no worse off than any lesser
;;; denominations; with floor(mod(n, 25)/10) dimes, we are no worse
;;; off than any lesser denomination, etc.
;;;
;;; For n cents, choose the largest c in {25, 10, 5, 1} such that c <=
;;; n; choose c, and recurse on n - c. If the optimal solution
;;; contains c, done; otherwise:
;;;
;;; 1 <= n < 5, c = 1: solution may only consist of pennies.
;;; 
;;; 5 <= n < 10, c = 5: if it contains only pennies, swap out five for
;;; a nickel.
;;;
;;; 10 <= n < 15, c = 10: if it contains only pennies and nickles,
;;; some subset can be replaced for a dime.
;;;
;;; 25 <= n, c = 25: replace three dimes with a quarter and nickel; or
;;; two dimes with a nickle or pennies.
;;;
;;; Since there is always an optimal solution with the greedy choice,
;;; the greedy algorithm produces an optimal solution.
(let ((denominations '(25 10 5 1)))
  (check (greedy-change denominations 67) =>
         '((1 . 2) (5 . 1) (10 . 1) (25 . 2))))

;;; b. Let k be max{0 <= k} c^k < n. With floor(n/c^k), we are no
;;; worse off than floor(n/c^{0 <= i < k}); with floor(mod(n,
;;; c^k)/c^{k-1}), etc.
;;;
;;; Find the maximum 0 <= i <= k such that c^i <= n; and recurse on
;;; the subproblem n - c^i.
;;;
;;; If, for any 0 <= i < j <= k, we have a_i * c^i >= a_j * c^j; where
;;; a_k is the amount of coins used at k denomination: we can a
;;; substitute c^j for j - i c^i coins.
(let ((c 2))
  (check (power-change c 1021) =>
         '((1 . 1) (2 . 0) (4 . 1)
           (8 . 1) (16 . 1) (32 . 1)
           (64 . 1) (128 . 1) (256 . 1)
           (512 . 1))))

;;; c. Three fives would have been better; in general, when there are
;;; higher denominations than the factors of n present whose common
;;; factors with n are not also present, the greedy solution can be
;;; fooled. (In the case below, 6 is present but not 3; 6 and 3 would
;;; have yielded a solution just as good as 5.)
(let ((denominations '(1 5 6)))
  (check (greedy-change denominations 15) =>
         '((1 . 3) (5 . 0) (6 . 2))))

;;; d. Dynamic solution where Sij expresses the optimal number of
;;; coins at denomination i and j cents; according to the recurrence:
;;;
;;; Sij = { j = 0 -> 0
;;;       { j < 0 -> +inf
;;;       {  else -> min{1 <= k <= i} Sk{j-di} + 1
;;;
;;; Si0 = 0 being our base case, assume that Sij is optimal; the next
;;; subproblem becomes min{1 <= k <= i+1} sk{j + dk}. Because the
;;; whole of S might have to be filled in, the complexity is O(nk).
(let ((denominations '(1 5 6)))
  (let-values (((s r) (dynamic-change denominations 15)))
    (check (make-change denominations s r) => '(5 5 5))))

(let ((denominations '(1 10 25)))
  (let-values (((s r) (dynamic-change denominations 30)))
    (check (make-change denominations s r) => '(10 10 10))))
