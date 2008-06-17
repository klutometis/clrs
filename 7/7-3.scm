(require-extension
 syntax-case)
(require '../7/chapter)
(import* chapter-7
         stooge-sort!)

(let ((vector ;; (vector 13 19 9 5 12 8 7 4 11 2 6 21)
              (vector 1 2 3)))
  (stooge-sort! vector 0 (- (vector-length vector) 1))
  vector)
