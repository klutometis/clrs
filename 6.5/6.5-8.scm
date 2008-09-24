(require-extension syntax-case
                   check)
(require '../6.5/section)
(import section-6.5)

;;; merge-append seems to require less work; make rigorous?
(check (min-heap-merge-append '(1 2 7 8)
                              '(3 4 5 10)
                              '(9 11 77 88))
       => '(1 2 3 4 5 7 8 9 10 11 77 88))

;;; The above is merely O(n lg n).
;;; 
;;; For O(n lg k), initialize the heap with the first element of all k
;;; lists; extract-min in O(lg k) and insert next element from the
;;; list that min belonged to n times for O(n(lg(k) + lg(k))) = O(2 n
;;; lg(k)) = O(n lg(k)).
