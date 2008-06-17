(require-extension syntax-case check)
(require '../9/chapter)
(import* chapter-9
         weighted-median-with-sort
         elt-weights)
(check (weighted-median-with-sort elt-weights) => 7)
