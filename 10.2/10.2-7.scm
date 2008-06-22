(require-extension
 syntax-case
 check)
(require '../10.2/section)
(import section-10.2)
(let ((slist (make-slist (make-sentinel))))
  (slist-insert! slist (make-slink 1 #f))
  (slist-insert! slist (make-slink 2 #f))
  (slist-insert! slist (make-slink 3 #f))
  (let ((keys (slist-keys slist)))
    (check (equal? keys (reverse (slist-keys (slist-reverse! slist))))
           => #t)))
