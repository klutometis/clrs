(require-extension syntax-case)
(require '../15.5/section)
(import section-15.5)
(let ((p (array-align (list->array 1 '(#f 0.15 0.10 0.05 0.10 0.20)) -1))
      (q (array-align (list->array 1 '(0.05 0.10 0.05 0.05 0.05 0.10)) -1)))
;;;   (let-values (((e root) (optimal-bst p q (- (car (array-dimensions p)) 1 1))))
;;;     (pretty-print (array->list e)))
  (let-values (((e root) (memoized-bst p q)))
    (pretty-print (array->list e)))
  )