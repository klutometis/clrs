(require-extension
 syntax-case
 array-lib
 array-lib-hof
 foof-loop
 (srfi 1 9 31 95))
(require '../srfi/srfi-70)
(require '../util/util)
(require '../16.3/section)
(module
 chapter-16
 (greedy-change
  power-change
  dynamic-change
  make-change
  make-task
  non-preemptive-schedule
  task-id
  average-completion)
 (import* srfi-70 exact-floor)
 (import* util debug)
 (import* section-16.3
          make-heap
          build-heap!
          heapsort!)
 (include "../16/change.scm")
 (include "../16/schedule.scm"))
