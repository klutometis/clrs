(define (unzip lists) (apply zip lists))

(define (divide k list)
  (loop ((with rest list (drop rest k))
         (for lists (listing (take rest k)))
         (until (< (length rest) k)))
        => (values lists rest)))

(define (k-sort k list)
  (let-values (((lists rest) (divide k list)))
    (append (apply append (map (cut sort <> <) (unzip lists)))
            rest)))
