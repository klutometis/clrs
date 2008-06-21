(require-extension
 syntax-case
 check)
(require '../10.2/section)
(import section-10.2)
(let ((stack (make-slist (make-sentinel))))
  (slist-push! stack 1)
  (slist-push! stack 2)
  (slist-push! stack 3)
  (check (slist-pop! stack) => 3))
