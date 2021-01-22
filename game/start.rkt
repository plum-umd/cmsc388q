#lang racket

(require 2htdp/image
           2htdp/universe)

(module+ test (require rackunit))

(module+ main
  (start-game))


(define (start-game)
  (big-bang (game (cons 20 20) 0)
    [on-key   game-press]
    [to-draw  game-draw]
  ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Types

;; type Game = (game Pos Coins)
(struct game (pos coins) #:prefab)

;; type Pos = (cons Int Int)

;; type Coins = Int

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Game

;; Game KeyEvent -> Game
(define (game-press g ke)
  (match g
    [(game pos coins)
     (match ke
       ["left"  (game (cons (- (car pos) 5) (cdr pos)) coins)]
       ["right" (game (cons (+ (car pos) 5) (cdr pos)) coins)]
       ["up"    (game (cons (car pos) (- (cdr pos) 5)) coins)]
       ["down"  (game (cons (car pos) (+ (cdr pos) 5)) coins)]
       )]
    ))

(module+ test
  (check-equal? (game-press (game (cons 20 20) 0) "left") "left"))
                



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw Gameboard

;; Game -> Image
(define (game-draw g)
  (match g
    [(game pos coins)
     (match pos
       [(cons x y) (place-image (square 20 "solid" "red") x y 
                                (place-image (square 21 "outline" "black") x y (empty-scene 500 500)))]
  )]))