(define-record-type :slist
  (make-slist nil)
  slist?
  (nil slist-nil))

(define-record-type :slink
  (make-slink key next)
  slink?
  (key slink-key set-slink-key!)
  (next slink-next set-slink-next!))

(define (make-sentinel)
  (let ((sentinel (make-slink '*sentinel* #f)))
    (set-slink-next! sentinel sentinel)
    sentinel))

(define (slist-insert! slist slink)
  (let ((sentinel (slist-nil slist)))
    (set-slink-next! slink (slink-next sentinel))
    (set-slink-next! sentinel slink)))

(define (slink-parent? parent child)
  (eq? (slink-next parent) child))

;;; Assumes slink is in list (otherwise, it will delete the first by
;;; default).
(define (slist-delete! slist ur-slink)
  (let* ((sentinel (slist-nil slist))
         (parent (slist-find/default
                  (cut slink-parent? <> ur-slink)
                  slist
                  sentinel)))
    (set-slink-next! parent (slink-next ur-slink))))

(define (slist-push! slist x)
  (let ((slink (make-slink x #f)))
    (slist-insert! slist slink)))

(define (slist-pop! slist)
  (let ((slink (slink-next (slist-nil slist))))
    (slist-delete! slist slink)
    (slink-key slink)))

(define (slist-for-each procedure slist)
  (let ((sentinel (slist-nil slist)))
    (loop ((with slink (slink-next sentinel) (slink-next slink))
           (until (eq? slink sentinel)))
          (procedure slink))))

(define (slist-map procedure slist)
  (let ((sentinel (slist-nil slist)))
    (loop ((with slink (slink-next sentinel) (slink-next slink))
           (for mapping (listing (procedure slink)))
           (until (eq? slink sentinel)))
          => mapping)))

(define (slink->string slink)
  (format "~A -> ~A; " (slink-key slink) (slink-key (slink-next slink))))

(define (slist-display slist)
  (slist-for-each (compose display slink->string) slist))

(define (slist-find predicate slist default)
  (call-with-current-continuation
   (lambda (return)
     (slist-for-each
      (lambda (slink) (if (predicate slink) (return slink))) slist)
     (default))))

(define (slist-find/default predicate slist default)
  (slist-find predicate slist (lambda () default)))

(define-record-type :slist-queue
  (make-slist-queue slist tail)
  slist-queue?
  (slist slist-queue-slist)
  (tail slist-queue-tail set-slist-queue-tail!))

(define (slist-enqueue! queue x)
  (let ((slink (make-slink x #f))
        (tail (slist-queue-tail queue))
        (sentinel (slist-nil (slist-queue-slist queue))))
    (set-slink-next! tail slink)
    (set-slist-queue-tail! queue slink)
    (set-slink-next! slink sentinel)))

(define (slist-dequeue! queue)
  (slist-pop! (slist-queue-slist queue)))
