(require-extension syntax-case check)
(require '../16.3/section)
(import section-16.3)

(let ((data '((4 . #f) (1 . #f) (3 . #f) (2 . #f) (16 . #f) (9 . #f)
              (10 . #f) (14 . #f) (8 . #f) (7 . #f))))
  (let ((max-heap
         (make-heap car set-car! > +inf (length data) (list-copy data))))
    (build-heap! max-heap)
    (check (heap-data max-heap) =>
           '((16 . #f) (14 . #f) (10 . #f) (8 . #f) (7 . #f) (9 . #f)
             (3 . #f) (2 . #f) (4 . #f) (1 . #f)))
    (check (heapsort! max-heap) =>
           '((16 . #f) (14 . #f) (10 . #f) (9 . #f) (8 . #f) (7 . #f)
             (4 . #f) (3 . #f) (2 . #f) (1 . #f))))
  (let ((min-heap
         (make-heap car set-car! < -inf (length data) (list-copy data))))
    (build-heap! min-heap)
    (check (heap-data min-heap) =>
           '((1 . #f) (2 . #f) (3 . #f) (4 . #f) (7 . #f) (9 . #f)
             (10 . #f) (14 . #f) (8 . #f) (16 . #f)))
    (check (heapsort! min-heap) =>
           '((1 . #f) (2 . #f) (3 . #f) (4 . #f) (7 . #f) (8 . #f)
             (9 . #f) (10 . #f) (14 . #f) (16 . #f)))))
