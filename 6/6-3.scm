(require-extension
 syntax-case
 check)
(require '../6/chapter)
(import chapter-6)
(let ((data '(10 2 4 7 8
                 3 5 6 9 +inf.0
                 +inf.0 +inf.0 +inf.0 +inf.0 +inf.0)))
  (check (tableau-data (tableauify (make-tableau 3 5 data) 0))
         => '(2 4 6 7 8 3 5 9 10 +inf +inf +inf +inf +inf +inf)))

(let ((data '(1 2 4 7 8
                3 5 6 9 +inf.0
                10 +inf.0 +inf.0 +inf.0 +inf.0)))
  (check (tableau-max-index (make-tableau 3 5 data))
         => 10))

(let* ((data '(1 2 4 7 8
                3 5 6 9 +inf.0
                10 +inf.0 +inf.0 +inf.0 +inf.0))
       (tableau (make-tableau 3 5 data)))
  (let ((min (tableau-extract-min tableau)))
    (check min => 1)
    (check (tableau-data tableau)
           => '(2 4 6 7 8
                  3 5 9 10 +inf
                  +inf +inf +inf +inf +inf))))

(let* ((data '(1 2 4 7 8
                3 5 6 9 +inf.0
                10 +inf.0 +inf.0 +inf.0 +inf.0))
       (tableau (make-tableau 3 5 data)))
  (check (tableau-data (tableau-insert tableau 0))
         => '(0 1 2 4 8 3 5 6 7 9 10 +inf +inf +inf +inf)))

(let* ((data '(1 2 4 7 8
                3 5 6 9 +inf.0
                10 +inf.0 +inf.0 +inf.0 +inf.0))
       (tableau (make-tableau 3 5 data)))
  (check (tableau-sort tableau)
         => '(10 9 8 7 6 5 4 3 2 1)))


(let* ((data '(1 2 4 7 8
                3 5 6 9 +inf.0
                10 +inf.0 +inf.0 +inf.0 +inf.0))
       (tableau (make-tableau 3 5 data)))
  (check (tableau-search tableau 7) => #t)
  (check (tableau-search tableau 11) => #f))
