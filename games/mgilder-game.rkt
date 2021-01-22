#lang racket

(require 2htdp/image)
(require 2htdp/universe)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants

(define TEXT-SIZE 30)
(define TEXT-COLOR "darkgreen")
(define BACKGROUND-COLOR "white")
(define METEOR-COLOR "purple")
(define LASER-COLOR "blue")
(define LASER-WIDTH 5)
(define LASER-LIFETIME 5)
(define HEIGHT 900)
(define WIDTH  900)

(define SPIN-SPEED 2)
(define METEOR-SPEED 2)
(define METEOR-SIZE 30)
(define SPAWN-DISTANCE (exact-floor (/ WIDTH 1.3)))

(define METEOR-IMAGE (circle METEOR-SIZE 100 METEOR-COLOR))

(define spaceship
  (scale 0.5 (rotate 90 (bitmap/url "https://www.cs.umd.edu/class/winter2021/cmsc388Q/shipBlue_manned.png"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Types

;; state -> ( tick    cooldown    meteors    effects  )

;; cooldown ->  last_shoot_tick

;; meteor ->  (  angle   birthtick  alive )

;; effect -> ( angle birthtick )     ;; this is for the lasers to be drawn and fade out

;; type State = (tick lastShoot (Listof Meteor) (Listof Effect))
(struct state (tick lastShoot meteors effects) #:prefab)

;; type Meteor = (angle birthTick)
(struct meteor (deg bTick) #:prefab)

;; type Effect = (angle birthTick)
(struct effect (deg bTick) #:prefab)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Launch a spinning blue spaceship
(module* main #f
  (big-bang (state 0 -9999 (cons (meteor 300 0) '()) '())
    [on-draw handleDraw]
    [on-tick handleTick]
    [stop-when handleDead]
    [on-key  handleKey]))

(define (checkMeteorDead m t)
    (match m
        ['() #f]
        [z (<= (gmeteor-dist z t) (* METEOR-SIZE 1.5))]))

(define (handleDead gameState)
    (match gameState
        [(state t l mlist elist)
            (> (length (filter (lambda (mm) (checkMeteorDead mm t)) mlist)) 0)]))


;; handleDraw
;;   1) draw layout + spaceship
;;   2) draw meteors
;;   3) draw effects
;;   4) draw score text

(define (handleDraw gameState)
    (match gameState
        [(state t l mlist elist) 
    (place-image/align (text (string-append "SCORE: " (number->string (exact-floor (/ t 60)))) TEXT-SIZE TEXT-COLOR) 0 HEIGHT "left" "bottom"
        (overlay (rotate (* -1 (* t SPIN-SPEED)) spaceship)
            (drawEffects elist t
                (drawMeteors mlist t
                    (empty-scene WIDTH HEIGHT BACKGROUND-COLOR)))))]))


;; handleTick
;;   increment tick counter
;;   spawn meteors (maybe every x ticks) (28 per second so maybe every 28?)
;;   check if game over (meteor hits)

(define (handleTick gameState)
    (match gameState
        [(state t l mlist elist) (state (+ t 1) l (newMeteor mlist t) (removeEffects elist t))]))



;; handleKey
;;   shoot with space, handle cooldown
;;   delete hit meteors

(define (handleKey gameState ke)
  (match ke
    [" " 
        (match gameState
            [(state t l mlist elist) (state t l (fireShot mlist t) (cons (effect (* t SPIN-SPEED) t) elist))])]
    [_ gameState]))


(define (newMeteor ml t)
    (if (= (modulo t 200) 0)
        (cons (meteor (random 360) t) ml)
        ml))

(define (angNorm a)
    (modulo (exact-floor a) 360))

;   (y - bound) <= x <= (y + bound)
(define (angleBounds x y bound)
    (<= (angNorm (abs (- x y))) bound) )

(define (shotTolerance m t)
    (max
        (- 90 (* (/ 180 pi) (acos (/ (* 1 METEOR-SIZE) (gmeteor-dist m t)))))
        (* (/ 180 pi) (asin (/ (* 1 METEOR-SIZE) (gmeteor-dist m t))))))

(define (shotHit m t)
    (match m
        [(meteor d b) (angleBounds (* t SPIN-SPEED) d (shotTolerance m t))]))

(define (fireShot ml t)
    (filter (lambda (m) (not (shotHit m t))) ml))

(define (livingEffect e t)
    (match e
        [(effect d b) (<= (- t b) LASER-LIFETIME)]))

(define (removeEffects el t)
    (filter (lambda (e) (livingEffect e t)) el))


(define (drawEffects el t base) 
    (match el
        [' () base]
        [(cons e es) 
            (match e
            [(effect d b)
                (scene+line (drawEffects es t base)
                    (/ WIDTH 2) (/ HEIGHT 2) (+ (/ WIDTH 2) (* (* 2 WIDTH) (cos (* d (/ pi 180.0))))) (+ (/ HEIGHT 2) (* (* 2 HEIGHT) (sin (* d (/ pi 180.0)))))
                    ;(color 0 0 255 (- 255 (* 255 (exact-floor (/ (- t b) LASER-LIFETIME)))) )
                    (make-pen LASER-COLOR LASER-WIDTH "solid" "round" "round")
)])]))


(define (gmeteor-dist m t)
    (match m
        [(meteor d b)
            (-
                SPAWN-DISTANCE 
                (* (- t b) METEOR-SPEED))]))

(define (gmeteor-x m t)
    (match m
        [(meteor d b) (+
                        (* 
                            (gmeteor-dist m t)
                            (cos (* d (/ pi 180))) )
                        (/ WIDTH 2))]))

(define (gmeteor-y m t)
    (match m
        [(meteor d b) (+ 
                        (* 
                            (gmeteor-dist m t)
                            (sin (* d (/ pi 180))) )
                        (/ HEIGHT 2))]))

(define (drawMeteors el t base) 
    (match el
        ['() base]
        ;[(cons e es) (place-image METEOR-IMAGE (gmeteor-x e t) (gmeteor-y e t) (drawMeteors es t base))]))
        [(cons e es)
            (match e [(meteor d b)
                    (scene+line (place-image METEOR-IMAGE (gmeteor-x e t) (gmeteor-y e t) (drawMeteors es t base))
                    (/ WIDTH 2) (/ HEIGHT 2) (+ (/ WIDTH 2) (* (* 2 WIDTH) (cos (* (- d (shotTolerance e t)) (/ pi 180.0))))) (+ (/ HEIGHT 2) (* (* 2 HEIGHT) (sin (* (- d (shotTolerance e t)) (/ pi 180.0)))))
                    ;(color 0 0 255 (- 255 (* 255 (exact-floor (/ (- t b) LASER-LIFETIME)))) )
                    (make-pen LASER-COLOR 1 "solid" "round" "round")
)])]))

