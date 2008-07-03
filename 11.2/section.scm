(require-extension
 syntax-case
 vector-lib)
(require '../10.2/section)
(module
 section-11.2
 (make-ch-element
  make-ch-table
  ch-search
  ch-insert!
  ch-delete!
  ch->vector
  identity-hash
  modulo-9-hash)
 (import* section-10.2
          dlist-empty?
          make-dlist
          make-dlink-sentinel
          dlist-insert!
          dlist-delete!
          dlink-key
          dlist-map)
 (include "../11.2/chained-hash.scm"))
