(require-extension check)
(require 'chapter)
(require '../20.2/section)
(require '../20.3/section)
(import chapter-20)
(import section-20.2)
(import section-20.3)
;;; a. If the new key is less than the old one, invoke
;;; heap-decrease-key for O(1) amortized; if the new key is the same,
;;; do nothing in O(1); if it is greater: cut the nodes children,
;;; inserting them into the root list; increase the key and cut the
;;; node itself, invoking cascade-cut on its parent. Increase the key
;;; on O(lg n) amortized, since D(n) <= O(lg n).
(let ((heap (figure-20.3)))
  (fibonacci-heap-change-key! heap (fibonacci-heap-min heap) +inf)
  (check (fibonacci-heap->list fibonacci-node-key heap) =>
         '((+inf)
           (17 (30))
           (24 (26 (35)) (46))
           (23)
           (7)
           (21)
           (18 (39))
           (52)
           (38 (41)))))

;;; b. Call heap-delete on min(r, N(H)) leaves in O(r) by maintaining
;;; a list of leaves with each root; no changes to the potential
;;; function.
