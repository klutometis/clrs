(require-extension syntax-case check)
(require '../10.4/section)
(import section-10.4)
(check (tree-map tree-node-key exercise-10.4-1) =>
       '(21 2 10 5 4 7 12 18))
