(require-extension syntax-case check)
(require '../16/chapter)
(import chapter-16)
;;; a.
(let ((denominations '(25 10 5 1)))
  (check (greedy-change denominations 67) =>
         '((1 . 2) (5 . 1) (10 . 1) (25 . 2))))

;;; b.
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

;;; d.
(let ((denominations '(1 5 6)))
  (let-values (((s r) (dynamic-change denominations 15)))
    (check (make-change denominations s r) => '(5 5 5))))

(let ((denominations '(1 10 25)))
  (let-values (((s r) (dynamic-change denominations 30)))
    (check (make-change denominations s r) => '(10 10 10))))
