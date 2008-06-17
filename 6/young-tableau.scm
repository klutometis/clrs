(define-record-type :tableau
  (make-tableau m n data)
  tableau?
  (m tableau-m)
  (n tableau-n)
  (data tableau-data))

(define (tableau-ref tableau index)
  (if (and index (check-index tableau index))
      (list-ref (tableau-data tableau) index)
      #f))

(define (tableau-size tableau)
  (* (tableau-m tableau) (tableau-n tableau)))

(define (check-index tableau index)
  (and (not (negative? index))
       (< index (tableau-size tableau))))

(define (wrap-right? tableau index)
  (zero? (modulo index (tableau-n tableau))))

(define (wrap-left? tableau index)
  (let ((n (tableau-n tableau)))
    (= (- n 1) (modulo index n))))

(define (right-index tableau index)
  (let ((right-index (+ index 1)))
    (if (check-index tableau right-index)
        (if (wrap-right? tableau right-index)
            #f
            right-index)
        #f)))

(define (down-index tableau index)
  (let ((down-index (+ index (tableau-n tableau))))
    (if (check-index tableau down-index)
        down-index
        #f)))

(define (left-index tableau index)
  (let ((left-index (- index 1)))
    (if (check-index tableau left-index)
        (if (wrap-left? tableau left-index)
            #f
            left-index)
        #f)))

(define (up-index tableau index)
  (let ((up-index (- index (tableau-n tableau))))
    (if (check-index tableau up-index)
        up-index
        #f)))

(define (tableau-swap! tableau swappend swappor)
  (if (and swappend swappor)
      (swap! (tableau-data tableau) swappend swappor)))

(define (neighbor-ref tableau index first-index second-index)
  (let ((first-index (first-index tableau index))
        (second-index (second-index tableau index)))
    (let ((first-ref (tableau-ref tableau first-index))
          (second-ref (tableau-ref tableau second-index))
          (ref (tableau-ref tableau index)))
      (values first-index second-index first-ref second-ref ref))))

(define (right-down-ref tableau index)
  (neighbor-ref tableau index right-index down-index))

(define (left-up-ref tableau index)
  (neighbor-ref tableau index left-index up-index))

(define (swap!-continue tableau continuation swappend swappor)
  (tableau-swap! tableau swappend swappor)
  (continuation tableau swappor))

(define (tableauify tableau index)
  (define (swap!-tableauify swappend swappor)
    (swap!-continue tableau tableauify swappend swappor))
  (let-values (((right-index down-index right-ref down-ref ref)
                (right-down-ref tableau index)))
    (if (and right-ref (> ref right-ref))
        (if (and down-ref (> right-ref down-ref))
            (swap!-tableauify index down-index)
            (swap!-tableauify index right-index))
        (if (and down-ref (> ref down-ref))
            (swap!-tableauify index down-index)
            tableau))))

;;; Need: tableau-walk?

(define (tableau-max-index tableau)
  (let iter ((index 0))
    (let-values (((right-index down-index right-ref down-ref ref)
                  (right-down-ref tableau index)))
      (if (and down-ref (finite? down-ref))
          (iter down-index)
          (if (and right-ref (finite? right-ref))
              (iter right-index)
              index)))))

(define (tableau-set! tableau index object)
  (list-set! (tableau-data tableau) index object))

(define (tableau-min tableau)
  (tableau-ref tableau 0))

(define (tableau-extract-min tableau)
  (let* ((max-index (tableau-max-index tableau))
         (max-ref (tableau-ref tableau max-index)))
    (let ((min-ref (tableau-min tableau)))
      (tableau-set! tableau max-index +inf.0)
      ;; Only bother retableauifying if there are any
      ;; indices left.
      (if (positive? max-index)
          (begin (tableau-set! tableau 0 max-ref)
                 (tableauify tableau 0)))
      min-ref)))

(define (tableau-index predicate tableau)
  (list-index predicate (tableau-data tableau)))

(define (tableau-first-empty tableau)
  (tableau-index infinite? tableau))

(define (tableau-insert tableau ref)
  (let ((index (tableau-first-empty tableau)))
    (tableau-set! tableau index -inf.0)
    (tableau-increase-index tableau index ref)))

(define (tableau-increase-index tableau index ref)
  (if (< ref (tableau-ref tableau index))
      (error "You're going down! -- TABLEAU-INCREASE-INDEX" ref)
      (begin
        (tableau-set! tableau index ref)
        (let loop ((tableau tableau)
                   (index index))
          (let-values (((left-index up-index left-ref up-ref ref)
                        (left-up-ref tableau index)))
            (if (and left-ref (< ref left-ref))
                (if (and up-ref (< left-ref up-ref))
                    (swap!-continue tableau loop index up-index)
                    (swap!-continue tableau loop index left-index))
                (if (and up-ref (< ref up-ref))
                    (swap!-continue tableau loop index up-index)
                    tableau)))))))

(define (tableau-empty? tableau)
  (infinite? (tableau-ref tableau 0)))

;;; Reverse; sorts in O(n(n + n)) = O(n^3) for an n x n.
(define (tableau-sort tableau)
  (let loop ((sortita '()))
    (if (tableau-empty? tableau)
        sortita
        (loop (cons (tableau-extract-min tableau) sortita)))))

(define (tableau-search tableau quaerendum)
  (let loop ((index 0))
    (let-values (((right-index down-index right-ref down-ref ref)
                  (right-down-ref tableau index)))
      (if (= ref quaerendum)
          #t
          (if (and right-ref (<= right-ref quaerendum))
              (loop right-index)
              (if (and down-ref (<= down-ref quaerendum))
                  (loop down-index)
                  #f))))))
