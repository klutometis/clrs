(require-extension syntax-case check)
(load "../5/chapter.scm")
(import chapter-5)

(define excutienda '(5 1 3 4 2))
(check (random-search 6 excutienda) => #f)
(check (deterministic-search 6 excutienda) => #f)
(check (scramble-search 6 excutienda) => #f)
