(require-extension
 syntax-case
 vector-lib
 foof-loop
 (srfi 9 11))
(require '../10.2/section)
(module
 section-11.2
 (make-ch-element
  make-ch-table
  ch-search
  ch-insert!
  ch-delete!
  ch->vector
  ch->list
  identity-hash
  modulo-9-hash
  modulo-3-hash
  make-lh-table
  lh-table-map
  lh-slot-flag
  lh-slot-p1
  lh-slot-p2
  lh-slot->string
  lh-table-insert!
  lh-table-delete!
  lh-table-search
  make-lh-element
  lh-table-key-data)
 (import* section-10.2
          slist-empty?
          make-slist
          make-slink
          make-sentinel
          slist-insert!
          slist-delete!
          slink-key
          slist-map
          slist-find/default)
 (include "../11.2/chained-hash.scm")
 (include "../11.2/linked-hash.scm"))
