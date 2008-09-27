(require-extension
 syntax-case
 array-lib
 (srfi 1 31 95))
(module
 section-16.2
 (binary-knapsack
  weights->items
  greedy-binary-knapsack
  minimize-stops
  fewest-enclosing-units
  maximize-payoff)
 (include "../16.2/knapsack.scm")
 (include "../16.2/gas.scm")
 (include "../16.2/units.scm")
 (include "../16.2/payoff.scm"))
