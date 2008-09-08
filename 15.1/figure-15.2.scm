(require-extension syntax-case check srfi-11 foof-loop array-lib)
(require '../15.1/section)
(import* section-15.1
         fastest-way)
(let ((a (list->array 2
                      '((7 9 3 4 8 4)
                        (8 5 6 4 5 7))))
      (t (list->array 2
                '((2 3 1 3 4)
                  (2 1 2 2 1))))
      (e0 2)
      (e1 4)
      (x0 3)
      (x1 2)
      (n 6))
  (let-values (((f l f* l*)
                (fastest-way a t e0 e1 x0 x1 n)))
    (check (array->list f) =>
           '((9 18 20 24 32 35)
             (12 16 22 25 30 37)))
    (check (array->list l) =>
           '((#f 0 1 0 0 1)
             (#f 0 1 0 1 1)))
    (check f* => 38)
    (check l* => 0)))
