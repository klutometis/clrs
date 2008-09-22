(require-extension syntax-case check)
(require '../16.1/section)
(import section-16.1)
(let* ((activities '((0 . 0)
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
  (check (activity-selector-across-rooms activities) =>
         '((0 (1 . 4) (5 . 7) (8 . 11) (12 . 14))
           (1 (3 . 5) (5 . 9))
           (2 (0 . 6) (6 . 10))
           (3 (3 . 8) (8 . 12))
           (4 (2 . 13)))))

;;; Each hall is optimally scheduled für sich, or we could fix it so
;;; that it is; as such, each hall has a maximum subset of
;;; activities. Since activities are maximized across halls, the
;;; cardinality of halls is minimized; otherwise, we could propose an
;;; optimal solution that minimized rooms.

;;; The result is a suboptimal Theta(n^2) algorithm that may use more
;;; rooms than necessary; see e.g. {[1, 4), [2, 5), [6, 7), [4, 8)}.
;;; O(n lg n) is possible, and more difficult.
