(require-extension
 syntax-case
 check)
(require '../10.2/section)
(import section-10.2)
(let ((slist (make-slist (make-sentinel))))
  (slist-insert! slist (make-slink 1 #f))
  (slist-insert! slist (make-slink 2 #f))
  (slist-insert! slist (make-slink 3 #f))
  (check (slink-key (slist-find-sans-nil-test slist 2)) => 2)
  (check (eq? (slist-nil slist) (slist-find-sans-nil-test slist 7))
         => #t))
