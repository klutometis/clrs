(require-extension check)
(require 'section)
(import section-23.2)
(let* ((MST (minimum-spanning-tree/kruskal (figure-23.1)))
       (edge-labels
         (map
          (lambda (edge)
            (let ((whence-label (node-label (edge-whence edge)))
                  (whither-label (node-label (edge-whither edge))))
              (cons whence-label whither-label))) MST)))
  (check
   edge-labels
   => '((d . e) (b . c) (c . d) (c . f) (a . b) (f . g) (i . c) (g . h))))
