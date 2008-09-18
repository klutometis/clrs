(require-extension
 syntax-case
 array-lib
 foof-loop
 (srfi 1 9 13 31 69 95))
(require '../util/util)
(require '../6.4/section)
(module
 chapter-15
 (memoized-bitonic-euclidean-salesman
  sort-by-x
  construct-path
  print-neatly
  lines
  print-lines
  make-sound
  memoized-find-path
  sound-path
  memoized-max-path
  max-path-cost
  max-path
  make-job
  sort-by-deadline
  schedule-max
  make-schedule
  job-spec->list
  edit-distance
  ops
  dna-alignment)
 (import* util sublist)
 (import* section-6.4 heapsort)
 (include "../15/bitonic-euclidean.scm")
 (include "../15/print-neatly.scm")
 (include "../15/viterbi.scm")
 (include "../15/scheduling.scm")
 (include "../15/edit-distance.scm"))
