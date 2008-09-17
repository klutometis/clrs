(define-record-type :sound
  (make-sound whence whither p label)
  sound?
  (whence sound-whence)
  (whither sound-whither)
  (p sound-p)
  (label sound-label))

(define (memoized-find-path G v0 sequence)
  (let* ((n (length sequence))
         (dim `(0 ,n)))
    (let ((s (make-array '#(#f) dim))
          (r (make-array '#(#f) dim)))
      (let ((iter-s
             (rec (iter-s i)
                  (if (negative? i)
                      #t
                      (let ((si (array-ref s i)))
                        (if si
                            si
                            (let ((si (list-ref sequence i)))
                              (loop ((for k (in-list (hash-table-ref G i))))
                                    (let ((q (and (eq? k si)
                                                  (iter-s (- i 1)))))
                                      (if (and (not (array-ref s i)) q)
                                          (begin
                                            (array-set! s #t i)
                                            (array-set! r k i)))))
                              (array-ref s i))))))))
        (iter-s (- n 1))
        (values s r)))))

(define (sound-path sequence)
  (if (last sequence)
      (append (map sound-whence sequence)
              (list (sound-whither (last sequence))))
      (error "No such path -- PATH")))

(define (memoized-max-path G v0 labels)
  (let* ((n (length labels))
         (x `(0 ,(hash-table-size G)))
         (y `(0 ,(+ n 1))))
    (let ((s (make-array '#(#f) x y))
          (r (make-array '#(#f) x y)))
      (let* ((adjacent-sounds
              (lambda (i label)
                (let ((sounds (hash-table-ref/default G i '())))
                  (filter
                   (lambda (sound) (string=? (sound-label sound) label))
                   sounds))))
             (iter-s
              (rec (iter-s i j)
                   (let ((sij (array-ref s i j)))
                     (if sij
                         sij
                         (if (or (= n i) (= n j))
                             (begin
                               (array-set! s i j 1)
                               1)
                             (let ((adj (adjacent-sounds i (list-ref labels j))))
                               (array-set! s 0 i j)
                               (loop ((for e (in-list adj)))
                                     (let ((q (* (sound-p e)
                                                 (iter-s (sound-whither e) (+ j 1)))))
                                       (if (> q (array-ref s i j))
                                           (begin
                                             (array-set! s q i j)
                                             (array-set! r e i j)))))
                               (array-ref s i j))))))))
        (iter-s 0 0)
        (values s r)))))

(define (max-path-cost s)
  (array-ref s 0 0))

(define (max-path r n)
  (let ((iter
         (rec (iter i j)
              (let ((sound (array-ref r i j)))
                (if sound
                    (let ((whither (sound-whither sound)))
                      (cons sound (iter whither (+ j 1))))
                    '())))))
    (iter 0 0)))
