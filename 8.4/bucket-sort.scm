(define (bucket-sort fortuita)
  (let* ((n (length fortuita))
         (buckets (make-vector n '())))
    (loop ((for fortuitum index (in-list fortuita))
           (let bucket-index (exact-floor (* n fortuitum))))
          (vector-set! buckets
                       bucket-index
                       (cons fortuitum
                             (vector-ref buckets bucket-index))))
    (loop ((for bucket (in-vector buckets))
           (for sortita (appending (insertion-sort bucket))))
          => sortita)))
