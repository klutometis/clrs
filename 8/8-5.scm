(require-extension syntax-case check)
(require '../8/chapter)
(require '../6.5/section)
(import* section-6.5
         min-heap-merge-append)
(import* chapter-8
         divide
         k-sort)

(check (k-sort 3 '(1 2 3 4 5 6 7 8 9 10))
       => '(1 4 7 2 5 8 3 6 9 10))
;;; O(n lg k)
(check (min-heap-merge-append '(1 4 7 2 5 8 3 6 9 10))
       => '(1 2 3 4 5 6 7 8 9 10))
