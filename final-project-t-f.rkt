#lang racket

;; Final Project (Sreyas Chacko)

;; Libraries
;; I used "first.rkt" and "client.rkt" to help me.
(require 2htdp/image
         2htdp/universe)

;; Variables and Constants
;; -------------------------------------------------------------------------------------------------------------------------------------------------
;; Introduction and Instructions
;; I used learned material from the class lectures.
(define intro
  (list "Hello. Welcome to Chacko's Quiz.\n\nPress Enter/Return to continue."
        (string-append "Instructions:\nAnswer the True/False questions correctly.\n(Note: The answers are locked in when they are selected.)\n\n"
                       "Commands:\n'T': True\n'F': False\n\nPress Enter/Return to continue. Press Backspace to go back.")
        "Press Enter/Return to start the quiz. Press Backspace to go back."))
;; U.S. Trivia Questions and Answers
;; I used knowledge that I obtained from the class lectures.
(define us-trivia-q-a
  (list
   (cons "Thomas Jefferson was the 3rd U.S. President." "T")
   (cons "Zachary Taylor was John Tyler's Vice President." "F")
   (cons "Andrew Jackson, the 7th U.S. President, was born in Pennsylvania." "F")
   (cons "Gerald Ford succeeded Richard Nixon as U.S. President." "T")
   (cons "Barnes was the middle name of the 36th U.S. President." "F")
   (cons "1880 was the year when the Mexican-American War ended." "F")
   (cons "Ronald Reagan was the former Governor of California." "T")
   (cons "Calvin Coolidge was Warren Harding's Vice President." "T")
   (cons "Grover Cleveland served three non-consecutive terms as U.S. President." "F")
   (cons "Alaska became a U.S. State during the Eisenhower administration." "T")))
;; Text Color
;; I was influenced by "client.rkt" from the class GitHub page.
(define T-COLOR "black")
;; Text Size
;; I was again influenced by "client.rkt" from the class GitHub page.
(define T-SIZE 20)

;; Functions/Methods
;; -------------------------------------------------------------------------------------------------------------------------------------------------
;; Question Obtainer
;; I used knowledge acquired from class to help me.
(define (question q-list num) (car (list-ref q-list num)))
;; Answer Verifier
;; I used knowledge obtained from class to help me.
(define (answer-v q-list num ans)
  (equal? (string-upcase ans) (cdr (list-ref q-list num))))
;; Percent Generator
;; I used knowledge learned from the class to help me.
(define (percent num q-list) (/ (* num 100.0) (length q-list)))
;; End-Result Generator
;; I used "first.rkt", "client.rkt", and knowledge obtained from class to help me.
(define (end-gen num q-list)
  (if (>= (percent num q-list) 70) (cons "Congratulations! You passed!" "green") (cons "You failed! Better luck next time!" "red")))
;; Screen
;; I used "first.rkt" and David's comments in the Discord #general chat to help me.
(define (screen params)
  (overlay (text/font (list-ref params 1) T-SIZE (list-ref params 2) #f 'default 'normal 'bold #f) (empty-scene 800 600)))
;; Key Commands
;; I used "first.rkt" and "client.rkt" to help me.
(define (key-cmds state k)
  (match k
    ["\r" (if (equal? (list-ref state 0) #f)
              (if (= (- (length (list-ref state 3)) 1) (list-ref state 4))
                  (list #t (question us-trivia-q-a 0) T-COLOR us-trivia-q-a 0 0)
                  (list #f (list-ref (list-ref state 3) (add1 (list-ref state 4))) T-COLOR (list-ref state 3) (add1 (list-ref state 4)) 0))
              state)]
    ["\b" (if (equal? (list-ref state 0) #f)
              (if (= 0 (list-ref state 4))
                  state
                  (list #f (list-ref (list-ref state 3) (sub1 (list-ref state 4))) T-COLOR (list-ref state 3) (sub1 (list-ref state 4)) 0))
              state)]
    [(or "t" "T" "f" "F") (if (equal? (list-ref state 3) us-trivia-q-a)
                              (if (= (- (length (list-ref state 3)) 1) (list-ref state 4))
                                  (if (equal? (answer-v (list-ref state 3) (list-ref state 4) (string-upcase k)) #t)
                                      (list #t (car (end-gen (add1 (list-ref state 5)) (list-ref state 3)))
                                            (cdr (end-gen (add1 (list-ref state 5)) (list-ref state 3))) (list) (list-ref state 4)
                                            (add1 (list-ref state 5)))
                                      (list #t (car (end-gen (list-ref state 5) (list-ref state 3)))
                                            (cdr (end-gen (list-ref state 5) (list-ref state 3))) (list) (list-ref state 4) (list-ref state 5)))
                                  (if (equal? (answer-v (list-ref state 3) (list-ref state 4) (string-upcase k)) #t)
                                      (list #t (question (list-ref state 3) (add1 (list-ref state 4))) T-COLOR (list-ref state 3)
                                            (add1 (list-ref state 4)) (add1 (list-ref state 5)))
                                      (list #t (question (list-ref state 3) (add1 (list-ref state 4))) T-COLOR (list-ref state 3)
                                            (add1 (list-ref state 4)) (list-ref state 5))))
                              state)]
    [_ state]))
;; Main module
;; I used "first.rkt" to help me.
(module* main #f
  (big-bang (list #f (list-ref intro 0) T-COLOR intro 0 0)
    [on-draw screen]
    [on-key key-cmds]))