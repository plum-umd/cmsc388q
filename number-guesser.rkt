#lang racket

(define answer (random 1 11))
(define yes 'Y)

(display "Welcome!")

(define (again)
  (set! answer (random 1 11))
  (display "Play again? Y/N")
  (define reply (read))
  (if(equal? yes reply)(game)(display "Thanks for playing!")))

(define (game)
  (display "Guess a number between 1 and 10.")
  (define guess (read))
  (if(equal? guess answer)(display "Congrats!!")(display "Sorry, try again."))
  (if(equal? guess answer)(again)(game)))

(game)
