#lang racket

(require 2htdp/image)
(require 2htdp/universe)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants

(define TEXT-SIZE 14)
(define BACKGROUND-COLOR "gray")
(define METEOR-COLOR "white")
(define LASER-COLOR "blue")
(define HEIGHT 900)
(define WIDTH  900)

(define spaceship
  (bitmap/url "https://www.cs.umd.edu/class/winter2021/cmsc388Q/shipBlue_manned.png"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Types

;; state -> ( tick    cooldown    meteors    effects  )

;; cooldown ->  last_shoot_tick

;; meteor ->  (  angle   birthtick  alive )

;; effect -> ( angle birthtick )     ;; this is for the lasers to be drawn and fade out

;; type State = (tick lastShoot (Listof Meteor) (Listof Effect))
(struct state (tick lastShoot meteors effects) #:prefab)

;; type Meteor = (angle birthTick alive)
(struct meteor (deg bTick alive) #:prefab)

;; type Effect = (angle birthTick)
(struct effect (deg bTick) #:prefab)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Launch a spinning blue spaceship
(module* main #f
  (big-bang (state 0 -9999 '() '())                ;(cons 0 "white")
    [on-draw handleDraw]
    [on-tick handleTick]
    [on-key  handleKey]))



;; handleDraw
;;   1) draw layout + spaceship
;;   2) draw meteors
;;   3) draw effects
;;   4) draw score text

(define (handleDraw gameState)
    (match gameState
        []
    (overlay (rotate (car i) spaceship)
           (empty-scene WIDTH HEIGHT BACKGROUND-COLOR)))



;; handleTick
;;   increment tick counter
;;   spawn meteors (maybe every x ticks) (28 per second so maybe every 28?)
;;   check if game over (meteor hits)

(define (handleTick gameState)
    (gameState))
  ;(overlay (rotate (car i) spaceship)
  ;         (empty-scene 900 900 (cdr i))))



;; handleKey
;;   shoot with space, handle cooldown
;;   delete hit meteors

(define (handleKey gameState ke)
  (match ke
    [" " (cons 0 (cdr i))]
    [_ gameState]))


(define (add5 x)
  (cons (+ (car x) 5)
        (cdr x)))
