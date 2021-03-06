(require-extension syntax-case check)
(require '../9/chapter)
(import* chapter-9
         weighted-median-with-sort)
(let ((points '((1 . 2)
                (8 . 3)
                (6 . 9)
                (4 . 0)
                (3 . 1)
                (2 . 6)
                (9 . 7)
                (7 . 8)
                (0 . 5)
                (5 . 4)))
      (weights '(1/16 1/16 1/16 1/16 1/4 1/4 1/16 1/16 1/16 1/16)))
  (let ((x (map car points))
        (y (map cdr points)))
    (check (cons (weighted-median-with-sort (map cons x weights))
                 (weighted-median-with-sort (map cons y weights)))
           => '(3 . 5))))
