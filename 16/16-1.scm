(require-extension syntax-case check)
(require '../16/chapter)
(import chapter-16)
;;; a. With floor(n/25) quarters, we are no worse off than any lesser
;;; denominations; with floor(mod(n, 25)/10) dimes, we are no worse
;;; off than any lesser denomination, etc.
(let ((denominations '(25 10 5 1)))
  (check (greedy-change denominations 67) =>
         '((1 . 2) (5 . 1) (10 . 1) (25 . 2))))

;;; b. Let k be max{0 <= k} c^k < n. With floor(n/c^k), we are no
;;; worse off than floor(n/c^{0 <= i < k}); with floor(mod(n,
;;; c^k)/c^{k-1}), etc.
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
