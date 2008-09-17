(require-extension
 syntax-case
 array-lib
 check
 (srfi 11 69))
(require '../15/chapter)
(import chapter-15)
;;; Modified HMM (hidden Markov model) for "data";
;;; http://www.jea.acm.org/ARTICLES/Vol2Nbr1/node4.html
(let ((s1 (make-sound 0 1 1 "d"))
      (s2 (make-sound 1 2 0.2 "ae"))
      (s3 (make-sound 1 5 0.4 "ae"))
      (s4 (make-sound 1 2 0.4 "ay"))
      (s5 (make-sound 2 3 0.4 "dx"))
      (s6 (make-sound 5 3 0.4 "dx"))
      (s7 (make-sound 2 3 0.2 "t"))
      (s8 (make-sound 3 4 1 "ax")))
  (let ((G (alist->hash-table
            `((0 . (,s1))
              (1 . (,s2 ,s3 ,s4))
              (2 . (,s5 ,s7))
              (3 . (,s8))
              (4)
              (5 . (,s6))))))
    (let-values (((s r) (memoized-find-path G 0 (list s1 s2 s5 s8))))
      (check (sound-path (array->list r)) => '(0 1 2 3 4)))
    (let ((labels (list "d" "ae" "dx" "ax")))
      (let-values (((s r) (memoized-max-path G 0 labels)))
        (check (round (* (max-path-cost s) 100)) => (round (* 0.16 100)))
        (check (sound-path (max-path r (length labels))) =>
               '(0 1 5 3 4))))))
