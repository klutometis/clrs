(require-extension
 syntax-case
 array-lib
 (srfi 31))
(module
 section-16.2
 (binary-knapsack
  weights->items
  greedy-binary-knapsack
  minimize-stops)
 (include "../16.2/knapsack.scm")
 (include "../16.2/gas.scm"))
