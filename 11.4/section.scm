(require-extension
 syntax-case
 foof-loop
 (srfi 9))
(module
 section-11.4
 (make-oa-table
  oa-table
  oa-insert!
  linear-probe
  quadratic-probe
  double-hash)
 (include "../11.4/open-addressing.scm"))
