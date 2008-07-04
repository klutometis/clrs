(define-record-type :lh-table
  (make-lh-table/internal table hash free)
  lh-table?
  (table lh-table)
  (hash lh-table-hash)
  (free lh-table-free set-lh-table-free!))

(define-record-type :lh-slot
  (make-lh-slot flag p1 p2)
  lh-slot?
  (flag lh-slot-flag set-lh-slot-flag!)
  (p1 lh-slot-p1 set-lh-slot-p1!)
  (p2 lh-slot-p2 set-lh-slot-p2!))

(define-record-type :lh-element
  (make-lh-element key datum)
  lh-element?
  (key lh-element-key)
  (datum lh-element-datum))

(define (make-lh-table n hash)
  (let ((table
         (vector-unfold (lambda (i)
                          (make-lh-slot #f
                                        (and (positive? i) (- i 1))
                                        (and (< i (- n 1)) (+ i 1))))
                        n)))
    (make-lh-table/internal table hash 0)))

(define (lh-table-map proc table) (vector-map proc (lh-table table)))

(define (lh-slot->string lh-slot)
  (format "flag: ~A; p1: ~A; p2: ~A"
          (lh-slot-flag lh-slot)
          (lh-slot-p1 lh-slot)
          (lh-slot-p2 lh-slot)))

(define (lh-slot-used? lh-slot)
  (lh-slot-flag lh-slot))

(define lh-slot-free? (complement lh-slot-used?))

(define (lh-table-slot-ref table key)
  (vector-ref (lh-table table) key))

(define (lh-table-slot-set! table key slot)
  (vector-set! (lh-table table) key slot))

(define (lh-table-free-delete! table slot)
  (let ((prev (lh-slot-p1 slot))
        (next (lh-slot-p2 slot)))
    (if prev (set-lh-slot-p2! (lh-table-slot-ref table prev) next))
    (if next (set-lh-slot-p1! (lh-table-slot-ref table next) prev))))

(define (lh-element-key-hash-slot table element)
  (let* ((key (lh-element-key element))
         (hash ((lh-table-hash table) key))
         (slot (lh-table-slot-ref table hash)))
    (values key hash slot)))

(define (lh-table-allocate! table)
  (let ((free (lh-table-free table)))
    (if free
        (let ((free-slot (lh-table-slot-ref table free)))
          (let* ((next-free (lh-slot-p2 free-slot))
                 (next-free-slot
                  (and next-free (lh-table-slot-ref table next-free))))
            (set-lh-table-free! table next-free)
            (if next-free-slot (set-lh-slot-p1! next-free-slot #f))
            free))
        (error "Slotless freedom -- TABLE-ALLOCATE!"))))

(define (lh-element-find-parent-slot table element)
  (let-values (((key hash slot)
                (lh-element-key-hash-slot table element)))
    (let continue ((parent (lh-table-slot-ref table hash)))
      (let ((next-hash (lh-slot-p2 parent)))
        (if next-hash
            (let* ((next-slot (lh-table-slot-ref table next-hash))
                   (next-element (lh-slot-p1 next-slot)))
              (if (eq? next-element element)
                  parent
                  (continue next-slot)))
            #f)))))

(define (lh-table-insert! table element)
  (let-values (((key hash slot)
                (lh-element-key-hash-slot table element)))
    (if (lh-slot-free? slot)
        (begin (lh-table-free-delete! table slot)
               (lh-table-slot-set! table hash (make-lh-slot #t element #f)))
        (let ((fore-element (lh-slot-p1 slot))
              (free-hash (lh-table-allocate! table)))
          (let-values (((fore-key fore-hash fore-slot)
                        (lh-element-key-hash-slot table fore-element)))
            (if (= hash fore-hash)
                (begin
                  (lh-table-slot-set! table free-hash
                                      (make-lh-slot #t element (lh-slot-p2 fore-slot)))
                  (set-lh-slot-p2! fore-slot free-hash))
                (let ((parent-slot (lh-element-find-parent-slot table fore-element)))
                  (if parent-slot
                      (begin (set-lh-slot-p2! parent-slot free-hash)
                             (lh-table-slot-set! table free-hash slot)
                             (lh-table-slot-set! table hash (make-lh-slot #t element #f)))
                      (error "Parentless alien -- TABLE-INSERT!")))))))))

(define (lh-table-key-data table)
  (loop ((for slot hash (in-vector (lh-table table)))
         (for key-data (listing
                        (let ((element (lh-slot-p1 slot)))
                          (if (lh-slot-flag slot)
                              (cons (lh-element-key element)
                                    (lh-element-datum element))
                              '())))))
        => key-data))

(define (lh-table-free! table hash)
  (let* ((free (lh-table-free table))
         (free-slot (and free (lh-table-slot-ref table free))))
    (lh-table-slot-set! table hash (make-lh-slot #f #f free))
    (if free (set-lh-slot-p1! free-slot hash))))

(define (lh-table-delete! table element)
  (let-values (((key hash slot)
                (lh-element-key-hash-slot table element)))
    (let* ((next (lh-slot-p2 slot))
           (next-slot (and next (lh-table-slot-ref table next))))
      (let ((fore-element (lh-slot-p1 slot)))
        (if (eq? element fore-element)
            (if next
                (begin
                  (lh-table-slot-set! table hash next-slot)
                  (lh-table-free! table next))
                (lh-table-free! table hash))
            (let ((parent-slot (lh-element-find-parent-slot table element)))
              (let* ((child (lh-slot-p2 parent-slot))
                     (child-slot (and child (lh-table-slot-ref table child))))
                (let ((grand-child (and child-slot (lh-slot-p2 child-slot))))
                  (if grand-child (set-lh-slot-p2! parent-slot grand-child))
                  (lh-table-free! table child)))))))))

(define (lh-table-search table key)
  (let* ((hash ((lh-table-hash table) key))
         (slot (lh-table-slot-ref table hash)))
    (if (lh-slot-free? slot)
        #f
        (let continue ((parent slot))
          (if parent
              (let* ((next (lh-slot-p2 slot))
                     (next-slot (lh-table-slot-ref table next)))
                (let ((element (lh-slot-p1 parent)))
                  (if (= (lh-element-key element) key)
                      (lh-element-datum element)
                      (continue next-slot))))
              #f)))))

(define modulo-3-hash (lambda (key) (modulo key 3)))
