(require-extension
 syntax-case
 array-lib
 array-lib-hof)
(module
 util
 (except?
  round-array
  sublist)
 (include "../util/test.scm")
 (include "../util/string.scm"))
