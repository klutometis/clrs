(define (infinite? z) (and (= z (* 2 z)) (not (zero? z))))
(define (finite? z) (not (infinite? z)))

(define (ipow-by-squaring x n acc proc)
  (cond ((zero? n) acc)
	((eqv? 1 n) (proc acc x))
	(else (ipow-by-squaring (proc x x)
				(quotient n 2)
				(if (even? n) acc (proc acc x))
				proc))))

(define (integer-expt x n) (ipow-by-squaring x n (if (exact? x) 1 1.) *))

(define (expt z1 z2)
  (cond ((and (exact? z2) (not (and (zero? z1) (negative? z2))))
	 (integer-expt z1 z2))
	((zero? z2) (+ 1 (* z1 z2)))
	(else (exp (* (if (zero? z1) (real-part z2) z2) (log z1))))))

(define integer-quotient quotient)
(define integer-remainder remainder)
(define integer-modulo modulo)

(define (quotient x1 x2)
  (if (and (integer? x1) (integer? x2))
      (integer-quotient x1 x2)
      (truncate (/ x1 x2))))

(define (remainder x1 x2)
  (if (and (integer? x1) (integer? x2))
      (integer-remainder x1 x2)
      (- x1 (* x2 (quotient x1 x2)))))

(define (modulo x1 x2)
  (if (and (integer? x1) (integer? x2))
      (integer-modulo x1 x2)
      (- x1 (* x2 (floor (/ x1 x2))))))

(define integer-lcm lcm)
(define integer-gcd gcd)

(define (lcm . args)
  (/ (apply integer-lcm (map numerator args))
     (apply integer-gcd (map denominator args))))

(define (gcd . args)
  (/ (apply integer-gcd (map numerator args))
     (apply integer-lcm (map denominator args))))

(define (exact-round x) (inexact->exact (round x)))
(define (exact-floor x) (inexact->exact (floor x)))
(define (exact-ceiling x) (inexact->exact (ceiling x)))
(define (exact-truncate x) (inexact->exact (truncate x)))
