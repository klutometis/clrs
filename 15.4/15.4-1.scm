(require-extension syntax-case check)
(require '../15.4/section)
(import section-15.4)
(let ((X '(1 0 0 1 0 1 0 1))
      (Y '(0 1 0 1 1 0 1 1 0)))
  (let-values (((c b) (lcs-length X Y)))
    (check (lcs b X (- (length X) 1) (- (length Y) 1)) =>
           '(1 0 0 1 1 0))))
