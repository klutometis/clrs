(require-extension syntax-case check (srfi 11))
(require '../16.1/section)
(import section-16.1)
(let ((activities '((0 . 0)
                    (1 . 4)
                    (3 . 5)
                    (0 . 6)
                    (5 . 7)
                    (3 . 8)
                    (5 . 9)
                    (6 . 10)
                    (8 . 11)
                    (8 . 12)
                    (2 . 13)
                    (12 . 14)
                    (+inf . +inf))))
  (let-values (((compatibles choices)
                (memoized-activity-selector
                 (sort-by-finishing-time activities))))
    ;; Doesn't work (extra 7 artifact).
    (check (choices->activities choices) => '(11 8 4 1))))
