(require-extension
 syntax-case
 array-lib
 check
 (srfi 11 13))
(require '../util/util)
(require '../15/chapter)
(import* util sublist)
(import chapter-15)
(let ((w (string-tokenize "When the objects of an inquiry, in any department, have principles, conditions, or elements, it is through acquaintance with these that knowledge, that is to say scientific knowledge, is attained. For we do not think that we know a thing until we are acquainted with its primary conditions or first principles, and have carried our analysis as far as its simplest elements. Plainly therefore in the science of Nature, as in other branches of study, our first task will be to try to determine what relates to its principles.")))
  (let-values (((cost break) (print-neatly 64 w)))
    (let ((lines (lines break (- (length w) 1))))
      (check lines => '((0 . 10) (11 . 20) (21 . 30) (31 . 44)
                        (45 . 54) (55 . 64) (65 . 75) (76 . 88)))
      (print-lines w lines))))
