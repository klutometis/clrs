(require-extension
 syntax-case
 foof-loop
 (srfi 9 26))
(module
 section-10.2
 (slist-insert!
  slist-delete!
  slist-push!
  slist-pop!
  slist-for-each
  make-sentinel
  make-slist
  make-slink
  slink->string
  slink-key
  slist-display
  slist-map
  slist-enqueue!
  slist-dequeue!
  make-slist-queue)
 (include "../10.2/linked-list.scm"))
