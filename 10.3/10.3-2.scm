(require-extension
 syntax-case
 check)
(require '../10.3/section)
(import section-10.3)
;;; From figure 10.7; block 4 still has a key since it's been cleared
;;; but not zeroed (see sarray-delete!).
;;;
;;; Indices are zero-origin here, contrary to the example.
(let ((list (make-sarray (vector #f #f #f
                                 4 2 4
                                 1 #f 1
                                 #f 7 #f
                                 16 1 6
                                 #f 0 #f
                                 9 4 #f
                                 #f 5 #f)
                         6 3)))
  (sarray-insert! list 25)
  (sarray-delete! list 4)
  (check (sarray-free list) => 4)
  (check (sarray-head list) => 3)
  (check (sarray-data list) => (vector #f #f #f
                                       4 2 6
                                       1 #f 1
                                       25 6 #f
                                       16 7 6
                                       #f 0 #f
                                       9 1 3
                                       #f 5 #f)))
