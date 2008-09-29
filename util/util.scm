(require-extension
 syntax-case
 array-lib
 array-lib-hof)
(module
 util
 (except?
  round-array
  sublist
  debug)
 (include "../util/test.scm")
 (include "../util/string.scm")
 (include "../util/debug.scm"))
