#lang racket

;; coded by: Maya Narayanasamy & Priya Mapara
;; used https://medium.com/@gjorgigjorgiev/guess-my-number-game-in-racket-3b47fe15a652 as a reference.
;; includes a random number generator

(displayln "Number Guessing Game ")
(newline)
(displayln "A simple program that will allow a user to enter a number.")
(displayln "The user wil try to guess the number that is predetermined.")
(displayln "If the number entered by the user is higher than the correct number,")
(displayln "the phrase 'Too high. Try Again.' will be printed. If the number is lower ")
(displayln "'Too Low. Try Again. will be printed.")
(displayln "the number.")
(newline)

;; holds the content of the messages that will be displayed.
(struct m (start-game guess-high guess-low win lose)) 
(define messages(m "Enter a number from 1-100: "  "\nThe number you guessed is too high. Try Again. ""\nThe number you guessed is too low. Try Again. "
                   "\n You gussed correctly!\n" "\nYou reached the maximum limit of guesses\n"))


;; max number of tries
(define (max-tries . args) 5)
;; the number to be guessed
(define (number . args) (random 100))
;; scanning user input
(define (user-guess . args)(read))
;; displaying the messages and check cases
(define (display-msg msg)(display msg))(define (make-game number guesses)(define (curr-game curr-guesses)
    (let ((curr-guess (user-guess)))
        (cond
         [(> number curr-guess )(display-msg (m-guess-low messages))(curr-game (+ 1 curr-guesses))]
         [(< number curr-guess)(display-msg (m-guess-high messages))(curr-game (+ 1 curr-guesses))]
         [(equal? curr-guess number)(display-msg (m-win messages))]
         [(= curr-guesses guesses) (display-msg (m-lose messages))])))
    curr-game)
;; starts the game
  (module* main #f (m-start-game messages)((make-game (number)(max-tries)) 1))