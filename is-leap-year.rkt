#lang racket

;; Coded by: Myckell Ronquillo, Maya Narayanasamy, and Priya Mapara

(displayln "Is leap year? ")
(newline)
(displayln "A simple program that checks if the year entered is a leap year.")
(displayln "To use this function, simply type in 'is-leap-year' and add the year")
(displayln "you would like to check to see whether it is a leap year or not.")
(newline)

(define (is-leap-year year)
  (if (equal? 0 (modulo year 400)) "This is a leap year" "This is not a leap year")
  (if (equal? 0 (modulo year 100)) "This is not a leap year" "This is not a leap year")
  (if (equal? 0 (modulo year 4)) "This is a leap year" "This is not a leap year"))




