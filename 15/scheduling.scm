(define-record-type :job
  (make-job number deadline time profit)
  job?
  (number job-number)
  (deadline job-deadline)
  (time job-time)
  (profit job-profit))

(define-record-type :job-spec
  (make-job-spec number start end profit)
  job-spec?
  (number job-spec-number)
  (end job-spec-end)
  (start job-spec-start)
  (profit job-spec-profit))

(define (job-spec->list job-spec)
  (list (job-spec-number job-spec)
        (job-spec-start job-spec)
        (job-spec-end job-spec)
        (job-spec-profit job-spec)))

(define (sort-by-deadline jobs)
  (sort jobs < job-deadline))

(define (schedule-max jobs)
  (let* ((n (length jobs))
         (x `(0 ,n))
         (y `(0 ,(* n n))))
    (let ((p (make-array '#(#f) x y))
          (r (make-array '#(#f) x y)))
      (let ((iter-t
             (rec (iter-t i t)
                  (let ((profit (array-ref p i t)))
                    (if profit
                        profit
                        (let ((job (list-ref jobs i)))
                          (let ((ti (job-time job))
                                (di (job-deadline job))
                                (pi (job-profit job)))
                            (cond ((zero? i)
                                   (let ((pt (if (= ti t)
                                                 (if (> t di)
                                                     0
                                                     pi)
                                                 0)))
                                     (array-set! p pt i t)))
                                  (else
                                   (let ((q (max (iter-t (- i 1) t)
                                                 (let ((pi-1
                                                        (iter-t (- i 1)
                                                                (- t ti))))
                                                   (if (> t di)
                                                       pi-1
                                                       (+ pi-1 pi))))))
                                     (array-set! p q i t)
                                     (array-set! r
                                                 (cons (- i 1) (- t ti))
                                                 i
                                                 t))))
                            (array-ref p i t))))))))
        (iter-t (- n 1) (- (* n n) 1))
        (values p r)))))

(define (make-schedule jobs p r i j)
  (let ((job (list-ref jobs i))
        (next-i-j (array-ref r i j))
        (profit (array-ref p i j)))
    (let ((job-end j)
          (job-start (+ (- j (job-time job)) 1))
          (job-number (job-number job)))
      (format #t "job: ~A; start: ~A; end: ~A; profit: ~A~%"
              job-number job-start job-end profit)
      (cons (make-job-spec job-number
                           job-start
                           job-end
                           profit)
            (if next-i-j
                (make-schedule jobs p r (car next-i-j) (cdr next-i-j))
                '())))))
