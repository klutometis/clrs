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

;;; Thanks, manas;
;;; http://coe02.proboards39.com/index.cgi?board=algos&action=display&thread=166
(define (slist-find-sans-nil-test slist k)
  (let ((sentinel (slist-nil slist)))
    (set-slink-key! sentinel k)
    (loop ((with slink (slink-next sentinel) (slink-next slink))
           (until (equal? (slink-key slink) k)))
          => slink)))

(define (slist-reverse! slist)
  (let ((sentinel (slist-nil slist))
        (reverse (make-slist (make-sentinel))))
    (loop continue ((with slink (slink-next sentinel))
                    (until (eq? sentinel slink)))
          (let ((next (slink-next slink)))
            (slist-delete! slist slink)
            (slist-insert! reverse slink)
            (continue (=> slink next))))
    reverse))

(define (slist-keys slist)
  (slist-map slink-key slist))

(define-record-type :dlist
  (make-dlist nil)
  dlist?
  (nil dlist-nil))

(define-record-type :dlink
  (make-dlink key prev next)
  dlink?
  (key dlink-key set-dlink-key!)
  (prev dlink-prev set-dlink-prev!)
  (next dlink-next set-dlink-next!))

(define (dlink! l1 l2)
  (set-dlink-next! l1 l2)
  (set-dlink-prev! l2 l1))

(define (make-dlink-sentinel)
  (let ((sentinel (make-dlink '*sentinel* #f #f)))
    (dlink! sentinel sentinel)
    sentinel))

(define (dlist-insert! dlist dlink)
  (let* ((sentinel (dlist-nil dlist))
         (next (dlink-next sentinel)))
    (dlink! sentinel dlink)
    (dlink! dlink next)))

(define (dlist-empty? dlist)
  (let ((sentinel (dlist-nil dlist)))
    (eq? sentinel (dlink-next sentinel))))

(define (dlist-sentinel-first-last dlist)
  (let ((sentinel (dlist-nil dlist)))
    (let ((first (dlink-next sentinel))
          (last (dlink-prev sentinel)))
      (values sentinel first last))))

(define (dlist-union! d1 d2)
  (cond ((dlist-empty? d1) d2)
        ((dlist-empty? d2) d1)
        (else (let-values (((d1-sentinel d1-first d1-last)
                            (dlist-sentinel-first-last d1))
                           ((d2-sentinel d2-first d2-last)
                            (dlist-sentinel-first-last d2)))
                (dlink! d1-last d2-first)
                (dlink! d2-last d1-sentinel)
                d1))))

(define (dlist-map proc dlist)
  (let ((sentinel (dlist-nil dlist)))
    (loop ((with dlink (dlink-next sentinel) (dlink-next dlink))
           (for mapping (listing (proc dlink)))
           (until (eq? sentinel dlink)))
          => mapping)))
