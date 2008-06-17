(require-extension
 syntax-case
 check)
(require '../8.3/section)
(import section-8.3)
(let ((numbers
       (vector
        (word "cow")
        (word "dog")
        (word "sea")
        (word "rug")
        (word "row")
        (word "mob")
        (word "box")
        (word "tab")
        (word "bar")
        (word "ear")
        (word "dig")
        (word "big")
        (word "tea")
        (word "now")
        (word "fox")
        )))
  (check
   (vector-map (lambda (i word) (word->string word 3))
               (radix-sort numbers 3))
   => '#("bar" "big" "box" "cow" "dig" "dog" "ear" "fox"
         "mob" "now" "row" "rug" "sea" "tab" "tea")))
