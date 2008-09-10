(require-extension
 syntax-case
 srfi-11
 array-lib
 check)
(require '../15.2/section)
(import section-15.2)
(let ((p '(30 35 15 5 10 20 25)))
  (let-values (((m s) (matrix-chain-order p)))
    (check (array->list m) =>
           '((0 15750 7875 9375 11875 15125)
             (+inf 0 2625 4375 7125 10500)
             (+inf +inf 0 750 2500 5375)
             (+inf +inf +inf 0 1000 3500)
             (+inf +inf +inf +inf 0 5000)
             (+inf +inf +inf +inf +inf 0)))
    (check (array->list s) =>
           '((#f 0 0 2 2 2)
             (#f #f 1 2 2 2)
             (#f #f #f 2 2 2)
             (#f #f #f #f 3 4)
             (#f #f #f #f #f 4)
             (#f #f #f #f #f #f)))))
