(require-extension syntax-case srfi-11 check)
(require '../15/chapter)
(import chapter-15)
(let ((X "algorithm")
      (Y "altruistic"))
  (let-values (((cost op) (edit-distance X Y)))
    (check (ops op (- (string-length X) 1) (- (string-length Y) 1)) =>
           '((insert . #\c) (replace . #\i) (replace . #\t)
             (replace . #\s) (replace . #\i) (replace . #\u)
             (replace . #\r) (replace . #\t) (replace . #\l)))))

(let ((X "GATCGGCAT")
      (Y "CAATGTGAATC"))
  (let-values (((cost op) (dna-alignment X Y)))
    (check (ops op (- (string-length X) 1) (- (string-length Y) 1)) =>
           '((insert . #\C) (insert . #\T) (replace . #\A)
             (replace . #\A) (replace . #\G) (replace . #\T)
             (replace . #\G) (replace . #\T) (replace . #\A)
             (replace . #\A)))))
