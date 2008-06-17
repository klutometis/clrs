(require-extension syntax-case check)
(require '../9.3/section)
(import* section-9.3
         dual-medians)
(let ((A (list 0 1 2 3 4 5))
      (B (list 0 10 20 30 40 50)))
  (check (dual-medians A B) => 4))
