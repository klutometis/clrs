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
   (vector-unfold (lambda (i) (make-dlist (make-dlink-sentinel))) length)
   hash))

(define (ch-search table key)
  (let ((slot (vector-ref (ch-table table) ((ch-hash table) key))))
    (if (dlist-empty? slot)
        #f
        slot)))

(define (ch-insert! table element)
  (dlist-insert! (vector-ref
                  (ch-table table)
                  ((ch-hash table) (ch-element-key element)))
                 (ch-element-datum element)))

(define (ch-delete! table element)
  (dlist-delete! (vector-ref
                  (ch-table table)
                  ((ch-hash table) (ch-element-key element)))
                 (ch-element-datum element)))

(define (ch->vector table)
  (vector-map (lambda (i dlist) (dlist-map dlink-key dlist)) (ch-table table)))

(define identity-hash (lambda (key) key))

(define modulo-9-hash (lambda (key) (modulo key 9)))
