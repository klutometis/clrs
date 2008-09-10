(require-extension
 syntax-case
 array-lib
 check)
(require '../15.2/section)
(import section-15.2)
(let ((A (list->array 2 '((1 0 2)
                          (-1 3 1))))
      (B (list->array 2 '((3 1)
                          (2 1)
                          (1 0)))))
  (check (array->list (matrix-multiply A B)) =>
         '((5 1) (4 2))))
