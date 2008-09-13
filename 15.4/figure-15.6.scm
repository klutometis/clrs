(require-extension syntax-case check)
(require '../15.4/section)
(import section-15.4)
(let ((X '(a b c b d a b))
      (Y '(b d c a b a)))
  (let-values (((c b) (lcs-length X Y)))
    (check (lcs b X (- (length X) 1) (- (length Y) 1)) =>
           '(b c b a))))
