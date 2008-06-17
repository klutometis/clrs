(require-extension
 syntax-case)
(require '../8.4/section)
(import section-8.4)
(let ((data (list .79 .13 .16 .64 .39 .20 .89 .53 .71 .42)))
  (bucket-sort data))
