(define-record-type :ch-element
  (make-ch-element key datum)
  ch-element?
  (key ch-element-key)
  (datum ch-element-datum))

(define-record-type :ch-table
  (make-ch-table/internal table hash)
  ch-table?
  (table ch-table)
  (hash ch-hash))

(define (make-ch-table length hash)
  (make-ch-table/internal
   (vector-unfold (lambda (i) (make-slist (make-sentinel))) length)
   hash))

(define (ch-search table key)
  (let* ((slot (vector-ref (ch-table table) ((ch-hash table) key)))
         (slink (slist-find/default
                 (lambda (slink) (= (ch-element-key (slink-key slink)) key))
                 slot
                 #f)))
    (and slink (ch-element-datum (slink-key slink)))))

(define (ch-insert! table element)
  (slist-insert! (vector-ref
                  (ch-table table)
                  ((ch-hash table) (ch-element-key element)))
                 (make-slink element #f)))

;;; Write off the Theta(n) of slist-delete! as alpha of Theta(1 +
;;; alpha).
(define (ch-delete! table element)
  (let* ((slist (vector-ref
                 (ch-table table)
                 ((ch-hash table) (ch-element-key element))))
         (slink (slist-find/default
                 (lambda (slink) (eq? element (slink-key slink)))
                 slist
                 #f)))
    (if slink
        (slist-delete! slist slink)
        (error "No such element -- DELETE!"))))

(define (ch->vector table)
  (vector-map (lambda (i slist)
                (cons i
                      (slist-map
                       (lambda (slink)
                         (let ((element (slink-key slink)))
                           (cons (ch-element-key element)
                                 (ch-element-datum element)))) slist)))
              (ch-table table)))

(define identity-hash (lambda (key) key))

(define modulo-9-hash (lambda (key) (modulo key 9)))
