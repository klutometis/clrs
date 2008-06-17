(require-extension
 syntax-case
 check)
(require '../9.1/section)
(import* section-9.1
         tournament-min)

;;; Runs in Theta(n) with Theta(n lg n) space complexity to store
;;; comparisons; subsequent tournaments can run therefore in Theta(lg
;;; n) by minimizing on n/2 compared values.
(let-values (((min comparisons)
              (tournament-min '(1 2 3 4 5))))
  (let-values (((min comparisons)
                (tournament-min comparisons)))
    (check min => 2)))
