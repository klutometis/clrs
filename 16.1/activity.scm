(define (memoized-activity-selector activities)
  (let* ((n (length activities))
         (dim `(0 ,n)))
    (let ((compatibles (make-array '#(#f) dim dim))
          (choices (make-array '#(#f) dim dim)))
      (let* ((compatible-activities
              (rec (compatible-activities i j)
                   (let ((fi (cdr (list-ref activities i)))
                         (sj (car (list-ref activities j))))
                     (filter (lambda (activity)
                               (let ((sk (car activity))
                                     (fk (cdr activity)))
                                 (and (<= fi sk)
                                      (< sk fk)
                                      (<= fk sj))))
                             activities))))
             (lookup-compatible
              (rec (lookup-compatible i j)
                   (let ((compatible (array-ref compatibles i j)))
                     (if compatible
                         compatible
                         (let ((compatible-activities
                                (compatible-activities i j)))
                           (array-set! compatibles 0 i j)
                           (if (not (null? compatible-activities))
                               (loop ((for k (up-from i (to j))))
                                     (if (member (list-ref activities k) compatible-activities)
                                         (let ((q (+ (lookup-compatible i k)
                                                     (lookup-compatible k j)
                                                     1)))
                                           (if (> q (array-ref compatibles i j))
                                               (begin (array-set! compatibles q i j)
                                                      (array-set! choices k i j)))))))
                           (array-ref compatibles i j)))))))
        (lookup-compatible 0 (- n 1))
        (values compatibles choices)))))

(define (sort-by-finishing-time activities)
  (sort activities < cdr))

(define (choices->activities choices)
  (delete-duplicates
   (array-fold
    (lambda (activities k)
      (if k (cons k activities) activities))
    '()
    choices)))

(define (recursive-activity-selector activities)
  (if (null? activities)
      '()
      (let* ((current-f (cdr (car activities)))
             (rest (find-tail
                    (lambda (next)
                      (let ((next-s (car next))
                            (next-f (cdr next)))
                        (and (positive? next-f)
                             (finite? next-s)
                             (>= (car next) current-f))))
                    (cdr activities))))
        (if rest
            (cons (car rest) (recursive-activity-selector rest))
            '()))))

(define (recursive-activity-selector-last activities)
  (if (null? activities)
      '()
      (let* ((current-s (car (last activities)))
             (first (take-while (lambda (next) (< (cdr next) current-s))
                                activities)))
        (if (null? first)
            '()
            (cons (last first) (recursive-activity-selector-last first))))))

(define (activity-selector-across-rooms activities)
  (let ((iter
         (rec (iter activities room)
              (if (or (null? activities)
                      (equal? activities '((0 . 0)
                                           (+inf . +inf))))
                  '()
                  (let* ((compatible-activities
                          (recursive-activity-selector activities))
                         (rest-activities
                          (lset-difference equal?
                                           activities
                                           compatible-activities)))
                    (cons (cons room compatible-activities)
                          (iter rest-activities (+ room 1))))))))
    (iter activities 0)))
