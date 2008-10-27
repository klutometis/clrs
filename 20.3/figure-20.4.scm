(require-extension check)
(require '../20.2/section)
(require 'section)
(import section-20.2)
(import section-20.3)
(let ((heap (figure-20.3)))
  (let* ((n46
          (fibonacci-node-right
           (fibonacci-node-child
            (fibonacci-node-right
             (fibonacci-node-right
              (fibonacci-heap-min heap))))))
         (n35
          (fibonacci-node-child
           (fibonacci-node-right
            n46))))
    (fibonacci-heap-extract-min! heap)
    (fibonacci-heap-decrease-key! heap n46 15)
    (check (fibonacci-heap->list fibonacci-node-key heap)
           => '((7 (23) (17 (30)) (24 (26 (35))))
                (18 (39) (21 (52)))
                (38 (41))
                (15)))
    (fibonacci-heap-decrease-key! heap n35 5)
    (check (fibonacci-heap->list fibonacci-node-key heap)
           => '((5)
                (26)
                (24)
                (7 (23) (17 (30)))
                (18 (39) (21 (52)))
                (38 (41))
                (15)))))
