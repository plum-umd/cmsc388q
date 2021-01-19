#lang racket

;racket <filename.rkt> //exe
;raco test <filename.rkt> //run all unit tests

#|

(module+ test (require rackunit))

(module+ test
  (check-equal? #t #f))
|#



#|
struct data structure

(struct foo (x y z))
(foo 1 2 (foo "third element"))

(define f (foo 1 2 3))

(foo-x f) ;;returns 1
(foo-y f) ;;returns 2
(foo-z f) ;;returns 3

;;returns sum of the 3 elements in the struct if they're integers
(match f
[(foo a b c) (+ a b c)]
)

(foo? f) --> is "f" a foo?? returns true


|#




#|

(equal? <value1> <value2>)  ;;works for all data types

(equal? (foo 1 2 3) (foo 1 2 3)) returns false UNLESS foo is defined as (struct foo (x y z) #:transparent)

|#



#|

(require 2htdp/image)

(text "String to Image" 30 "any color")

(beside (text "String to Image1" 30 "blue")
        (text "String to Image2" 30 "red")
)

(above (text "String to Image1" 30 "blue")
        (text "String to Image2" 30 "red")
)

(above/align "left"
        (text "String to Image1" 30 "blue")
        (text "String to Image2" 30 "red")
)
|#