(require-extension syntax-case check)
(require '../9/chapter)
(import* chapter-9
         weighted-median-with-select
         elt-weights)
(check (weighted-median-with-select elt-weights) => 7)
