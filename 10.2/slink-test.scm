(require-extension
 syntax-case
 check)
(require '../10.2/section)
(import section-10.2)
(let ((slist (make-slist (make-sentinel)))
      (a (make-slink 'a #f))
      (b (make-slink 'b #f))
      (c (make-slink 'c #f)))
  (slist-insert! slist a)
  (slist-insert! slist b)
  (slist-insert! slist c)
  (slist-delete! slist c)
  (check (slist-map slink-key slist) => '(b a)))
