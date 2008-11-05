(require-extension srfi-69)
(require 'section)
(import section-23.2)
;; (map
;;  (lambda (edge)
;;    (list
;;     (set-map set-member-datum (edge-whence edge))
;;     (set-map set-member-datum (edge-whither edge))))
;;  (minimum-spanning-tree/kruskal (figure-23.1)))
(minimum-spanning-tree/kruskal (figure-23.1))
;; (print (alist->hash-table (figure-23.1)))
