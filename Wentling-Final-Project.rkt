#lang racket

; BREAKOUT
; By: Joshua Wentling

; -------------------------------------------------------------------------------

; This project is a very basic version of the popular Atari game Breakout.
; The user wins by destroying bricks on the screen by bouncing a moving ball
; off of their paddle. If the ball passes their paddle, they lose.

; -------------------------------------------------------------------------------

; NOTE: I was hoping to have a completed game by the end of the semester, however
; I didn't get a change to complete everything (CMSC388A and CMSC388B kicked
; my butt this past week). The current version has a functioning ball, paddle,
; and a single brick. Some TODOs are listed below for what I still need to
; complete to get a finished game working.

; NOTE 2: Thank you for everything this semester. The relaxed and collaborative
; nature of this course has been a breath of fresh air in comparison to the
; structure of most other CS courses. I thoroughly enjoyed the lectures and had
; a lot of fun making this project. Also, thank you for being so responsive and
; engaging with us on Discord and during lecture, I can't emphasize enough how
; much of a difference that makes to me (us) as students. I don't normally write
; notes like this to my professors, but I wanted to write you a quick thank you
; since you have been so helpful. Best wishes, and stay safe! :)

; -------------------------------------------------------------------------------

; Future TODOs
; Add more bricks (likely using some sort of list and recursive function)
; Add a scoring system
; Add menu to start/pause/restart/quit game
; Adjust angle of the ball according to where on the paddle it hit
; Add levels
; Add sound effects

; -------------------------------------------------------------------------------

(require 2htdp/image 2htdp/universe)

; dimensions and color of screen
(define width 500)
(define height 400)
(define background "black")
; ball velicty/radius
(define velocity 2)
(define radius 10)
; paddle distance to bottom of screen
(define paddle-y-loc (- height 10))
; paddle dimensions
(define paddle-height 10)
(define paddle-width 40)
;size and location of brick
(define brick-width 40)
(define brick-height 10)
(define brick-x (* width (/ 2 5)))
(define brick-y (* height (/ 1 3)))

; Note to self
; constant: world size, paddle size, ball size, brick locations
; variable: paddle x, ball x and y, brick exists (#t or #f)
; variables need to be a part of the world definition

; Scene and image definitions
(define (blank)
  (empty-scene width height background))

(define paddle-img
  (rectangle paddle-width paddle-height "solid" "white"))

(define ball-img
  (circle radius "solid" "gray"))

(define brick-img
  (rectangle brick-width brick-height "solid" "white"))

; World structure containing paddle, brick, and ball structures
(struct world (paddle ball brick))
(struct paddle (x))
(struct ball (angle x y))
(struct brick (exists))

; Initialize world
(define first-world
  (world (paddle (/ width 2))
         (ball (/ pi 4)(- width 100)(* height (/ 1 4)))
         (brick #t)))

; Start big-bang
(module* main #f
  (big-bang first-world
    [on-draw draw-everything]
    [on-tick update-ball 1/56] ; 1/28 was too choppy
    [on-key update-paddle]))

; Draw all the images on the world each time the
; world is updated
(define (draw-everything w)
  (draw-brick (world-brick w)
   (draw-ball (world-ball w)
     (draw-paddle (world-paddle w) (blank)))))

; Draw methods take their respective struct and an image
; to overlay on top of
(define (draw-paddle p img)
  (place-image paddle-img (paddle-x p) paddle-y-loc img) )

(define (draw-ball b img)
  (place-image ball-img (ball-x b) (ball-y b) img) )

(define (draw-brick br img)
  (cond
    [(equal? #t (brick-exists br)) ; only draw if brick exists
     (place-image brick-img brick-x brick-y img)]
    [else img]))

(define (update-ball w)
  (world (world-paddle w)
         (new-ball (world-ball w) (world-paddle w) (world-brick w))
         (new-brick (world-ball w) (world-brick w))))
;         (ball (new-angle (world-ball w))
;               (new-ball-x (ball-x (world-ball w))(ball-angle (world-ball w)))
;               (new-ball-y (ball-y (world-ball w))(ball-angle (world-ball w)))
;               ) ) )

; Check to see if ball hits brick. If so, remove it
(define (new-brick curr-ball curr-brick)
  (define (curr-brick-exists) (brick-exists curr-brick))
  (define (curr-x) (ball-x curr-ball))
  (define (curr-y) (ball-y curr-ball))
  (define (curr-angle) (ball-angle curr-ball))
  (define (new-x) (+ (curr-x) (* (cos (curr-angle)) velocity)))
  (define (new-y) (+ (curr-y) (* (sin (curr-angle)) velocity)))
  (cond
    [(equal? #f (curr-brick-exists)) ; Don't do anythign if already destroyed
     (brick #f)]
    ; Check if new ball location is within the brick. If so, remove it
    [(and (and (>= (+ (new-x) radius) (- brick-x (/ brick-width 2)))
          (<= (+ (new-x) radius) (+ brick-x (/ brick-width 2))))
          (and (>= (+ (new-y) radius) (- brick-y (/ brick-height 2)))
          (<= (+ (new-y) radius) (+ brick-y (/ brick-height 2)))))
     (brick #f)]
    [else (brick #t)]))
    

; Calculate new x and y location for the ball. If the ball hits the edge
; of the screen, the paddle, or a brick then adjust its angle accordingly
(define (new-ball curr-ball curr-paddle curr-brick)
  (define (curr-paddle-x) (paddle-x curr-paddle))
  (define (curr-x) (ball-x curr-ball))
  (define (curr-y) (ball-y curr-ball))
  (define (curr-angle) (ball-angle curr-ball))
  (define (curr-brick-exists) (brick-exists curr-brick))
  (define (new-x) (+ (curr-x) (* (cos (curr-angle)) velocity)))
  (define (new-y) (+ (curr-y) (* (sin (curr-angle)) velocity)))
  (cond ;calculate new angle
    ; Check if ball reaches left or right of screen
    [(or (>= (new-x) (- width radius))(<= (new-x) radius))
     (ball (- pi (curr-angle))(curr-x)(curr-y))]
    ; Check if ball reaches top of screen
    [(<= (new-y) radius)
     (ball (- (* 2 pi) (curr-angle))(curr-x)(curr-y))]
    ; Check if ball hits paddle
    [(and (>= (+ (new-y) radius) (- paddle-y-loc (/ paddle-height 2)))
          (and (> (new-x)(- (curr-paddle-x)(/ paddle-width 2)))
               (< (new-x)(+ (curr-paddle-x)(/ paddle-width 2)))))
     (ball (- (* 2 pi) (curr-angle))(new-x)(curr-y))]
    ; Check if ball hits brick
    [(and (equal? #t (curr-brick-exists))
     (and (and (>= (+ (new-x) radius) (- brick-x (/ brick-width 2)))
          (<= (+ (new-x) radius) (+ brick-x (/ brick-width 2))))
          (and (>= (+ (new-y) radius) (- brick-y (/ brick-height 2)))
          (<= (+ (new-y) radius) (+ brick-y (/ brick-height 2))))))
     (ball (- (* 2 pi) (curr-angle))(curr-x)(curr-y))]
    ; Otherwise, return ball with new values
    [else (ball (curr-angle)(new-x)(new-y))]))

; Update paddle location according to user input
(define (update-paddle w ke)
  (match ke
    ["right" (world (paddle (+ (paddle-x (world-paddle w)) 10))
                    (world-ball w)
                    (world-brick w))]
    ["left" (world (paddle (- (paddle-x (world-paddle w)) 10))
                   (world-ball w)
                   (world-brick w))]
    [_ w]))



;(define (new-ball-x curr-x curr-angle)
;  (cond
;    [(< (+ curr-x (* (cos curr-angle) velocity)) (- width 10))
;     (+ curr-x (* (cos curr-angle) velocity))]
;    [else (- curr-x 1)]))
;(define (new-ball-y curr-y curr-angle)
;  (cond
;    [(> (+ curr-y (* (sin curr-angle) velocity)) 0)
;     (+ curr-y (* (sin curr-angle) velocity))]
;    [else (curr-y 100)]))
;(define (new-angle curr-ball)
;  (cond 
;    [(and (>= (ball-x curr-ball) (- width 10)) (< (ball-angle curr-ball) (/ pi 2))) ;condition
;     (- pi (ball-angle curr-ball))] ;result
;    [(and (>= (ball-x curr-ball) (- width 10)) (> (ball-angle curr-ball) (/ pi 2))) ;condition
;     (+ pi (ball-angle curr-ball))] ;result
;    [(and (<= (ball-x curr-ball) 0) (< (ball-angle curr-ball) (/ pi 2))) ;condition
;     (+ 0 (ball-angle curr-ball))] ;result
;    [(and (<= (ball-x curr-ball) 0) (> (ball-angle curr-ball) (/ pi 2))) ;condition
;     (- pi (ball-angle curr-ball))] ;result
;    [else (ball-angle curr-ball)]))