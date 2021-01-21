#lang racket

(require 2htdp/image)
(require 2htdp/universe)

;; First value of state is the colors (TL, TR, BL, BR), second value is score
(module* main #f
  (big-bang (cons (list 0 1 2 3) 0)
    [on-draw draw]
    [on-tick rand-color 3/4]
    [on-mouse click]))
 

;; height of the game window
(define HEIGHT 600)
;; width of the game window
(define WIDTH 400)

;; draws the 4 rectangles to make up the game scene
;; Game-state -> Image
(define (draw i)
  (match i
    [(cons (list a b c d) n)
     (overlay/align "middle" "top"
                    (text "Click red to win points" 24 "black")
                    (overlay/align "left" "top"
                                   (text (number->string (cdr i)) 24 "black")
                                   (above (beside (empty-scene (/ WIDTH 2) (/ HEIGHT 2) (get-color a))
                                                  (empty-scene (/ WIDTH 2) (/ HEIGHT 2) (get-color b)))
                                          (beside (empty-scene (/ WIDTH 2) (/ HEIGHT 2) (get-color c))
                                                  (empty-scene (/ WIDTH 2) (/ HEIGHT 2) (get-color d))))))])) 

;; sets the list of colors in the state to random values
;; Game-state -> Game-state
(define (rand-color i)
  (let ([a (random 6)])
    (let ([b (random 6)])
      (let ([c (random 6)])
        (let ([d (random 6)])
          (cons (list a b c d) (cdr i)))))))

;; returns the color represented by the given number
;; int -> String (color)
(define (get-color x)
  (match x
    [0 "red"]
    [1 "orange"]
    [2 "yellow"]
    [3 "green"]
    [4 "blue"]
    [5 "purple"]))

;; Updates the score of the game depending on where the user clicked
;; Game-state int int mouse-event -> Game-state
(define (click i x y e)
  (match e
    ["button-up"
     (match i
       [(cons (list a b c d) n)
        (match (< x (/ WIDTH 2))
          [#t
           (match (< y (/ HEIGHT 2))
             [#t
              (match a
                [0 (cons (list a b c d) (add1 n))]
                [_ (cons (list a b c d) (sub1 n))])]
             [#f
              (match c
                [0 (cons (list a b c d) (add1 n))]
                [_ (cons (list a b c d) (sub1 n))])])]
          [#f
           (match (< y (/ HEIGHT 2))
             [#t
              (match b
                [0 (cons (list a b c d) (add1 n))]
                [_ (cons (list a b c d) (sub1 n))])]
             [#f
              (match d
                [0 (cons (list a b c d) (add1 n))]
                [_ (cons (list a b c d) (sub1 n))])])])])]
   
    [_ i]))
  