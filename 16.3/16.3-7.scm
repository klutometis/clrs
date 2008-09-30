(require-extension syntax-case check (srfi 1 27))
(require '../12.1/section)
(require '../16.3/section)
(import section-12.1)
(import section-16.3)
(let ((frequencies (unfold (lambda (x) (> x 255))
                           (lambda (x)
                             (let ((key (+ 100 (- (random-integer 64) 32))))
                               (make-bt-node key
                                             (number->string x)
                                             #f
                                             #f
                                             #f)))
                           (lambda (x) (+ x 1))
                           0)))
  (pretty-print (huffman-codes (huffman! frequencies))))

;;; The tree of a fixed-length code is similar to an optimal tree of
;;; nearly identical frequencies, since every node is a least frequent
;;; node; and appears, therefore, in the bottom-most leaves. In fact,
;;; the entire tree consists of bottom-most leaves.
;;; 
;;; The only way a node can be promoted is if it is more frequent than
;;; at least two leaves; which is impossible if the greatest frequency
;;; is less that twice the minimum.
