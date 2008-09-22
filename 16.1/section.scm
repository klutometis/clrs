(require-extension
 syntax-case
 foof-loop
 array-lib
 array-lib-hof
 (srfi 1 95))
(module
 section-16.1
 (memoized-activity-selector
  sort-by-finishing-time
  choices->activities
  recursive-activity-selector)
 (include "../16.1/activity.scm"))
