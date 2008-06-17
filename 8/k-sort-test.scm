;;; k-sort a list A such that: Sigma^{i+k-1}_{j=i}A[j]/k <=
;;; Sigma^{i+k}_{j=i+1}A[j]/k

;; (require-extension syntax-case foof-loop (srfi 11 26 95))

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

(k-sort 3 '(1 2 3 4 5 6 7 8 9 10))
;;; (1 4 7 2 5 8 3 6 9 10)
