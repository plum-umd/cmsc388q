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

(+ 1 2)

(string-append "fred" "wilma")

(define x 3.14)

(define (f y)
  (expt 2 y))


(define spaceship
  (bitmap/url "https://www.cs.umd.edu/class/winter2021/cmsc388Q/shipBlue_manned.png"))


(overlay (scale .7 spaceship)
         (rectangle 400 200 "solid" "yellow"))


;; (Cons Integer Color) -> Image
(define (spin i)
  (overlay (rotate (car i) spaceship)
           (empty-scene 300 300 (cdr i))))

(require 2htdp/universe)

;(animate spin)

(define (reset i ke)
  (match ke
    [" " (cons 0 (cdr i))]
    ["r" (cons (car i) "red")]
    ["y" (cons (car i) "yellow")]
    ["p" (cons (car i) "purple")]
    [_ i]))

(define (add5 x)
  (cons (+ (car x) 5)
        (cdr x)))
