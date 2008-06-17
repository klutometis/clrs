(require-extension syntax-case)
(load "section.scm")
(import section-5.4)

(define elts '(1 2 3 4 5))
(randomize-in-place-cyclic elts)
