(require-extension syntax-case check)
(require '../12.1/section)
(require '../16.3/section)
(import section-12.1)
(import section-16.3)
(let ((frequencies (list (make-bt-node 1 "a" #f #f #f)
                         (make-bt-node 1 "b" #f #f #f)
                         (make-bt-node 2 "c" #f #f #f)
                         (make-bt-node 3 "d" #f #f #f)
                         (make-bt-node 5 "e" #f #f #f)
                         (make-bt-node 8 "f" #f #f #f)
                         (make-bt-node 13 "g" #f #f #f)
                         (make-bt-node 21 "h" #f #f #f))))
;;;   (check (huffman-codes (huffman! frequencies)) =>
;;;          '(((1 1 1 1 1 1 1) . "b") ((1 1 1 1 1 1 0) . "a")
;;;            ((1 1 1 1 1 0) . "c") ((1 1 1 1 0) . "d")
;;;            ((1 1 1 0) . "e") ((1 1 0) . "f")
;;;            ((1 0) . "g") ((0) . "h")))
;;;   (print (bt-node-datum (huffman! frequencies)))
  (huffman-tree (huffman! frequencies)))

;;; Where Dt(c_i) is the height of a given node in the tree, its
;;; Fibonacci encoding is {1}^(Dt(c_i)-1){0}; except for the last
;;; node, whose encoding is {1}^Dt(c_i).

;;; For two nodes code(0) = 0 and code(1) = 0, this is palpably the
;;; case; assume it holds for c_0 .. c_k. Add note c_{k+1}, where
;;; f(k+1) = f(k) + f(k - 1); c_{k+1} will be the most frequent leaf
;;; and must be placed (without loss of generality) to the left of the
;;; root.

;;; f(k), the next most frequest leaf, will be placed (without loss of
;;; generality) to the right of the root; sibling to the graft that
;;; connects c_{k-1} and its graft until c_0 and c_1 are yoked
;;; together.
