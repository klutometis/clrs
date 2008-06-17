(require-extension
 syntax-case
 check
 (srfi 1))
(require '../8/chapter)
(import* chapter-8
         compare-jugs
         compare-jugs-random)

(let ((reds '(1 2 3))
      (blues '(3 2 1)))
  (check (compare-jugs reds blues)
         => '((1 . 1) (2 . 2) (3 . 3))))

(let ((reds '(1 2 3))
      (blues '(3 2 1)))
  (check (compare-jugs-random reds blues)
         (=> (lambda (a b)
               (and (= (length a) (length b))
                    (every (lambda (elt) (member elt b)) a))))
         '((1 . 1) (2 . 2) (3 . 3))))
