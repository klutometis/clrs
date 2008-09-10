(require-extension
 syntax-case
 srfi-11
 array-lib
 check)
(require '../15.2/section)
(import section-15.2)
(let ((p '(5 10 3 12 5 50 6)))
  (let-values (((m s) (matrix-chain-order p)))
    (check (array->list m) =>
           '((0 150 330 405 1655 2010)
             (+inf 0 360 330 2430 1950)
             (+inf +inf 0 180 930 1770)
             (+inf +inf +inf 0 3000 1860)
             (+inf +inf +inf +inf 0 1500)
             (+inf +inf +inf +inf +inf 0)))
    (check (array->list s) =>
           '((#f 0 1 1 3 1)
             (#f #f 1 1 1 1)
             (#f #f #f 2 3 3)
             (#f #f #f #f 3 3)
             (#f #f #f #f #f 4)
             (#f #f #f #f #f #f)))))
