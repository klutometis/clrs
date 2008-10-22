(require-extension check)
(require '../20.2/section)
(require '../util/util)
(import* util debug)
(import section-20.2)
(let ((heap (figure-20.3)))
  (check (fibonacci-node-key (fibonacci-heap-extract-min! heap))
         => 3)
  (check (fibonacci-heap->list fibonacci-node-key heap) =>
         '((7 (23) (17 (30)) (24 (26 (35)) (46)))
           (18 (39) (21 (52)))
           (38 (41))))
  (check (map fibonacci-node-key
              (let iter ((keys '()))
                (if (fibonacci-heap-empty? heap)
                    keys
                    (iter (cons (fibonacci-heap-extract-min! heap)
                                keys)))))
         => '(52 46 41 39 38 35 30 26 24 23 21 18 17 7)))
