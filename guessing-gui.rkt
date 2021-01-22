; This program is a simple guessing game with a gui
; Coded by Myckell Ronquillo

#lang racket
(require 2htdp/universe 2htdp/image)

; Guessing range 
(struct range (min max))

; Help text
(define TOP-TEXT
  (text "Up Arrow if # > current, Down Arrow if # < current"
        20
        "black"))
(define BOTTOM-TEXT
  (text "Press SPACE if curr # is correct"
        20
        "black"))

; Screen display settings
(define SCREEN-DISP
  (place-image/align
   TOP-TEXT 3 10 "left" "top"
   (place-image/align
    BOTTOM-TEXT 3 130 "left" "bottom"
    (empty-scene 475 150))))

; Key-Events
(define (deal-with-guess n key)
  (cond [(key=? key "up") (bigger n)]
        [(key=? key "down") (smaller n)]
        [(key=? key " ") (stop-with n)]     
        [else n]))

; If number is less than current
(define (smaller n)
  (range (range-min n)
            (max (range-min n) (sub1 (guess n)))))

; If number is greater than current
(define (bigger n)
  (range (min (range-max n) (add1 (guess n)))
            (range-max n)))

; Does the binary search
(define (guess n)
  (quotient (+ (range-min n) (range-max n)) 2))

; Rendering
(define (render n)
  (overlay (text (number->string (guess n)) 32 "red") SCREEN-DISP))

(define (render-last-scene n)
  (overlay (text (string-append "Your number is: " (number->string (guess n))) 32 "green") SCREEN-DISP))

; If number is found
(define (single? n)
  (= (range-min n) (range-max n)))

; Main
(define (start lower upper)
  (big-bang (range lower upper)
           (on-key deal-with-guess)
           (to-draw render)
           (stop-when single? render-last-scene)))