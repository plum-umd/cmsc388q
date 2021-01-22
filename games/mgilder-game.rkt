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

(define COOLDOWN 20)

(define SPIN-SPEED 3/2)
(define METEOR-SPEED 1)
(define METEOR-INTERVAL 50)
(define METEOR-SIZE 60)
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
  (big-bang (state 0 -9999 (cons (meteor 0 0) '()) '())
    [on-draw handleDraw]
    [on-tick handleTick]
    [stop-when handleDead]
    [on-key  handleKey]))

(define (checkMeteorDead m t)
    (match m
        ['() #f]
        [z (<= (gmeteor-dist z t) (* METEOR-SIZE 1.2))]))

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
    (place-image/align (text (string-append "SCORE: " (number->string (exact-floor (/ t 28)))) TEXT-SIZE TEXT-COLOR) 0 HEIGHT "left" "bottom"
        (overlay (rotate (* -1 (* t SPIN-SPEED)) spaceship)
            (drawEffects elist t
                (drawMeteors mlist t
                    (empty-scene WIDTH HEIGHT BACKGROUND-COLOR)))))]))


;; handleTick
;;   increment tick counter
;;   spawn meteors (maybe every x ticks) (28 per second so maybe every 28?)
;;   check if game over (meteor hits)
;;   remove old lasers(i.e effects)

(define (handleTick gameState)
    (match gameState
        [(state t l mlist elist) (state (+ t 1) l (newMeteor mlist t) (removeEffects elist t))]))



;; handleKey
;;   shoot with spacebar + handle cooldown
;;   delete meteors that are hit
;;   add effects (lasers)

(define (handleKey gameState ke)
  (match ke
    [" " 
        (match gameState
            [(state t l mlist elist) (if (>= (- t l) COOLDOWN) 
                (state t t (fireShot mlist t) (cons (effect (* t SPIN-SPEED) t) elist))
                (state t l mlist elist))])]
                
    [_ gameState]))

;; spawn a new meteor
(define (newMeteor ml t)
    (if (= (modulo t METEOR-INTERVAL) 0)
        (cons (meteor (random 360) t) ml)
        ml))

;; get the min differance between two angles  ->  i.e.   359deg and 1deg are close not far apart
(define (angDiff x y)
    (min (angNorm (- x y)) (- 360 (angNorm (- x y)))))

(define (angNorm a)
    (modulo (exact-floor a) 360))

;   (y - bound) <= x <= (y + bound)
(define (angleBounds x y bound)
    ;(or (<= (angNorm (abs (- x y))) bound) (<= (angNorm (abs (- y x))) bound) ))
    ;(<= (angNorm (- (max (angNorm x) (angNorm y)) (min (angNorm x) (angNorm y)))) bound))
    (<= (angDiff x y) bound))

; get angle of error for given meteor ( so you don't have to hit perfect center)
(define (shotTolerance m t)
    (max
        (- 90 (* (/ 180 pi) (acos (/ (* 1 METEOR-SIZE) (gmeteor-dist m t)))))
        (* (/ 180 pi) (asin (/ (* 1 METEOR-SIZE) (gmeteor-dist m t))))))

; did the current shot hit meteor m
(define (shotHit m t)
    (match m
        [(meteor d b) (angleBounds (* t SPIN-SPEED) d (shotTolerance m t))]))

; perform a laser shot and remove hit meteors
(define (fireShot ml t)
    (filter (lambda (m) (not (shotHit m t))) ml))

; is effect e alive
(define (livingEffect e t)
    (match e
        [(effect d b) (<= (- t b) LASER-LIFETIME)]))

; filter out expired effects (i.e. lasers)
(define (removeEffects el t)
    (filter (lambda (e) (livingEffect e t)) el))

; draw effects (lasers)
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


; get meteor m distance to center
(define (gmeteor-dist m t)
    (match m
        [(meteor d b)
            (-
                SPAWN-DISTANCE 
                (* (- t b) METEOR-SPEED))]))

; get meteor m x-distance to center
(define (gmeteor-x m t)
    (match m
        [(meteor d b) (+
                        (* 
                            (gmeteor-dist m t)
                            (cos (* d (/ pi 180))) )
                        (/ WIDTH 2))]))

; get meteor m y-distance to center
(define (gmeteor-y m t)
    (match m
        [(meteor d b) (+ 
                        (* 
                            (gmeteor-dist m t)
                            (sin (* d (/ pi 180))) )
                        (/ HEIGHT 2))]))

; draw all meteors
(define (drawMeteors el t base) 
    (match el
        ['() base]
        [(cons e es) (place-image METEOR-IMAGE (gmeteor-x e t) (gmeteor-y e t) (drawMeteors es t base))]))
        ; below is for debugging hitboxes
        ;[(cons e es)
            ;(match e [(meteor d b)
            ;        (scene+line (place-image METEOR-IMAGE (gmeteor-x e t) (gmeteor-y e t) (drawMeteors es t base))
            ;        (/ WIDTH 2) (/ HEIGHT 2) (+ (/ WIDTH 2) (* (* 2 WIDTH) (cos (* (- d (shotTolerance e t)) (/ pi 180.0))))) (+ (/ HEIGHT 2) (* (* 2 HEIGHT) (sin (* (- d (shotTolerance e t)) (/ pi 180.0)))))
            ;        (make-pen LASER-COLOR 1 "solid" "round" "round")
;)])]))

