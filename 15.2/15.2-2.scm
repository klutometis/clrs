(require-extension
 syntax-case
 srfi-11
 array-lib
 check)
(require '../15.2/section)
(import section-15.2)
(let* ((p '(5 10 3 12 5))
       (matrices (random-matrices p))
       (product (matrix-chain-multiply/straight matrices)))
  (let-values (((m s) (matrix-chain-order p)))
    (check (matrix-chain-multiply
            matrices
            s
            0
            (- (length matrices) 1)) =>
            product)))
