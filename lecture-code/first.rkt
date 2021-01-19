#lang racket

;; This is the program we wrote in class, but without any embedded images
;; so the source remains in a human-readable format

;; see first-embed.rkt for the one with the embedded images

(require 2htdp/image)

;; Launch a spinning blue spaceship
(module* main #f
  (big-bang (cons 0 "white")
    [on-draw spin]
    [on-tick add5 1/28]
    [on-key reset]))



(define spaceship
  (bitmap/url "https://www.cs.umd.edu/class/winter2021/cmsc388Q/shipBlue_manned.png"))

(define width 1000)
(define length 1000)

;; (Cons Integer Color) -> Image
(define (spin i)
  (overlay (rotate (car i) spaceship)
           (empty-scene 1000 1000 (cdr i))))

(require 2htdp/universe)

;(animate spin)


;; added more colors 
(define (reset i ke)
  (match ke
    [" " (cons 0 (cdr i))]
    
    ["left" (cons (car i) "cyan" )]
    ["right" (cons (car i) "purple")]
    ["up" (cons (car i) "green")]
    ["down" (cons (car i) "blue")]
    [_ i]))

(define (add5 x)
  (cons (+ (car x) 5)
        (cdr x)))
