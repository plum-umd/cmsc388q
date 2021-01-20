#lang racket
(require 2htdp/image)

;; Launch a spinning blue spaceship
(module* main #f
  (big-bang (cons (cons (random -275 275) (random -275 275)) (cons 0 #t))
    [on-draw spin]
    [on-tick endG 5]
    [on-key reset]
    [on-mouse move]))


(define spaceship
  (scale .5 (bitmap/url "https://www.cs.umd.edu/class/winter2021/cmsc388Q/shipBlue_manned.png")))

(define box (square 50 "solid" "red"))


(define (mRand i)
  (cons (cons (random -275 275) (random -275 275)) (cdr i)))

(define (endG i) (cons (car i) (cons (car (cdr i)) #f)))

;; (Cons Coordinates Color) -> Image
(define (spin i)
  (if (cdr (cdr i)) (overlay/offset box (car (car i)) (cdr (car i)) (empty-scene 600 600 "white"))
      (overlay (text (string-append "You scored: " (number->string (car (cdr i)))) 22 "red") (empty-scene 600 600 "white"))))

(require 2htdp/universe)

;(animate spin)

(define (reset i ke)
  (match ke
    [" " (cons '(0 . 0) (cdr i))]
    ["up" (cons (cons (car (car i))(+ 5 (cdr (car i)))) (cdr i))]
    ["down" (cons (cons (car (car i))(- (cdr (car i)) 10)) (cdr i))]
    ["left" (cons (cons (+ 5 (car (car i)))(cdr (car i))) (cdr i))]
    ["right" (cons (cons (- (car (car i)) 5)(cdr (car i))) (cdr i))]
    [_ i]))


(define (move i x y event)
  (match event
    ["button-down" (if (and (and (> x (- 275 (car (car i)))) (< x (- 325 (car (car i)))))
                                                                       (and (> y (- 275 (cdr (car i)))) (< y (- 325 (cdr (car i))))))
                                                                       (mRand (cons (car i) (cons (+ (car (cdr i)) 1) (cdr (cdr i))))) i)]
    ;;["button-down" (cons (cons (- 300 x) (- 300 y)) (cdr i))]
    [_ i]))

(define (add5 x)
  (cons (+ (car x) 5)
        (cdr x)))