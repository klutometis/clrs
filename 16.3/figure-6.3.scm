(require-extension syntax-case check)
(require '../16.3/section)
(import section-16.3)

(let ((data '((4 . #f) (1 . #f) (3 . #f) (2 . #f) (16 . #f) (9 . #f)
              (10 . #f) (14 . #f) (8 . #f) (7 . #f))))
  (let ((max-heap
         (make-heap car set-car! > -inf (length data) (list-copy data))))
    (build-heap! max-heap)
    (check (heap-data max-heap) =>
           '((16 . #f) (14 . #f) (10 . #f) (8 . #f) (7 . #f) (9 . #f)
             (3 . #f) (2 . #f) (4 . #f) (1 . #f)))
    (check (heapsort! max-heap) =>
           '((16 . #f) (14 . #f) (10 . #f) (9 . #f) (8 . #f) (7 . #f)
             (4 . #f) (3 . #f) (2 . #f) (1 . #f))))
  (let ((min-heap
         (make-heap car set-car! < +inf (length data) (list-copy data))))
    (build-heap! min-heap)
    (check (heap-data min-heap) =>
           '((1 . #f) (2 . #f) (3 . #f) (4 . #f) (7 . #f) (9 . #f)
             (10 . #f) (14 . #f) (8 . #f) (16 . #f)))
    (check (heapsort! min-heap) =>
           '((1 . #f) (2 . #f) (3 . #f) (4 . #f) (7 . #f) (8 . #f)
             (9 . #f) (10 . #f) (14 . #f) (16 . #f)))))

(let ((heap (make-heap car set-car! > -inf 0 '())))
  (heap-insert! heap '(1 . #f))
  (heap-insert! heap '(2 . #f))
  (heap-insert! heap '(3 . #f))
  (heap-insert! heap '(4 . #f))
  (heap-insert! heap '(5 . #f))
  (heap-insert! heap '(6 . #f))
  (heap-insert! heap '(7 . #f))
  (check (heap-data heap) =>
         '((7 . #f) (4 . #f) (6 . #f) (1 . #f) (3 . #f) (2 . #f) (5 . #f))))

(let ((heap (make-heap car set-car! < +inf 0 '())))
  (heap-insert! heap '(1 . #f))
  (heap-insert! heap '(2 . #f))
  (heap-insert! heap '(3 . #f))
  (heap-insert! heap '(4 . #f))
  (heap-insert! heap '(5 . #f))
  (heap-insert! heap '(6 . #f))
  (heap-insert! heap '(7 . #f))
  (check (heap-data heap) =>
         '((1 . #f) (2 . #f) (3 . #f) (4 . #f) (5 . #f) (6 . #f) (7 . #f))))
