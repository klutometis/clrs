(require-extension syntax-case check)
(require '../15.4/section)
(import section-15.4)
(let ((X '(1 0 0 1 0 1 0 1))
      (Y '(0 1 0 1 1 0 1 1 0)))
  (check (lcs-length/2n Y X) => 6)
  (check (lcs-length/n Y X) => 6))