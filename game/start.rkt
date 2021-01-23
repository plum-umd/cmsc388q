#lang racket

(require 2htdp/image
           2htdp/universe)

(module+ test (require rackunit))

(module+ main
  (start-game))


(define (start-game)
  (big-bang (game (cons 20 20) cns)
    [on-key   game-press]
    [to-draw  game-draw]
  ))

;Coin locations
(define cns '((235 . 325) (155 . 50) (100 . 54) (120 . 100) (50 . 200) (345 . 115) (275 . 279) (407 . 333) (459 . 100) (255 . 432)))
(define NUMC 10)
(define points 0)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Types

;; type Game = (game Pos Coins)
(struct game (pos coins) #:prefab)

;; type Pos = (cons Int Int)

;; type Coins = Int

;; type Pts = Int

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Game

;; Game KeyEvent -> Game
(define (game-press g ke)
  (match g
    [(game pos coins)
     (match ke
       ["left"  (game (cons (- (car pos) 5) (cdr pos)) (checkcoins pos coins))]
       ["right" (game (cons (+ (car pos) 5) (cdr pos)) (checkcoins pos coins))]
       ["up"    (game (cons (car pos) (- (cdr pos) 5)) (checkcoins pos coins))]
       ["down"  (game (cons (car pos) (+ (cdr pos) 5)) (checkcoins pos coins))]
       )]
    ))

;;Get rid of collected coins
(define (checkcoins pos coins)
  ;(print coins)
  (filter (λ (i) (let ((dis (sqrt (+ (expt (- (car i) (car pos)) 2) (expt (- (cdr i) (car pos)) 2))))) (if (< dis 20)
      (let ((one (add1 points))) #t)
      #f))) coins))


(module+ test
)                



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw Gameboard

;; Game -> Image
(define (game-draw g)
  (match g
    [(game pos coins)
     (match pos
       [(cons x y) (place-image (square 20 "solid" "red") x y 
                                (place-image (square 21 "outline" "black") x y (drawcoins coins)))]
  )]))

;;Compose place-image calls to draw the coins
(define (drawcoins coins)
  (match coins
    ['() (empty-scene 500 500)]
    [(cons (cons x y) rest) (place-image (circle 15 "solid" "yellow") x y (drawcoins rest))]
    )
  )





