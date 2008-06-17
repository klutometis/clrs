(require-extension syntax-case)

(module
 srfi-70
 (infinite?
  finite?
  expt
  gcd
  lcm
  quotient
  modulo
  remainder
  exact-round
  exact-ceiling
  exact-floor
  exact-truncate)
 (include "../srfi/srfi-70-impl.scm"))
