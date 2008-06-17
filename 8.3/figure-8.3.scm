(require-extension
 syntax-case
 check)
(require '../8.3/section)
(import section-8.3)
(let ((numbers
       (vector
        (number 329)
        (number 457)
        (number 657)
        (number 839)
        (number 436)
        (number 720)
        (number 355)
        )))
  (check
   (vector-map
    (lambda (i x) (number->integer x 3 10)) (radix-sort numbers 3))
   => '#(329 355 436 457 657 720 839)))
