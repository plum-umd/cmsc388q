#lang racket

(require 2htdp/image
         2htdp/universe
         rackunit)

(define ghost-img .)
(define pacman-img .)

(define title . )

(define score .)



(define dot (circle 10 "solid" "white"))
(define eaten_dot (circle 10 "solid" "black"))

(define dot_coords (list 
          (cons (random 60 550) (random 100 550) )
          (cons (random 60 550) (random 100 550) )
          (cons (random 60 550) (random 100 550) )
          (cons (random 60 550) (random 100 550) )))

(define c1 (car (first dot_coords)))
(define c2 (cdr (first dot_coords)))
(define c3 (car (second dot_coords)))
(define c4 (cdr (second dot_coords)))
(define c5 (car (third dot_coords)))
(define c6 (cdr (third dot_coords)))
(define c7 (car (fourth dot_coords)))
(define c8 (cdr (fourth dot_coords)))


(define background
  (place-image score 500 40
  (place-image dot c1 c2
  (place-image dot c3 c4
  (place-image dot c5 c6
  (place-image dot c7 c8
  (place-image title 250 40 (empty-scene 600 600 "black"))))))))


(struct pacman (x y dir) #:transparent)
(struct ghost  (x y dir) #:transparent)

(struct game (pacman ghost) #:transparent)


(define (p)
  (big-bang (game (pacman 15 180 "right")
                  (ghost 300 80 "down"))
    [on-tick tick-game]
    [on-key  key-game]
    [to-draw draw-game]))


;; Game -> Image
(define (draw-game g)
  (match g
    [(game (pacman p-x p-y p-dir) (ghost g-x g-y g-dir))
     (place-image pacman-img
                  p-x
                  p-y
                  (place-image ghost-img
                               g-x
                               g-y
                               background))]))


;;(module+ test
  ;;(check-equal?
  ;; (tick-game (game (pacman 20 10 "left") (ghost 40 30 "down")))
  ;; (game (pacman 18 10 "left") (ghost 40 32 "down"))))


;; tick

;; Game -> Game
(define (tick-game g)
  (match g
    [(game pm gh)
     (game (tick-pacman pm) (tick-ghost gh))]))

;;(module+ test
  ;;(check-equal?
   ;;(tick-pacman (pacman 20 10 "left"))
 ;;  (pacman 18 10 "left")))

(define coor-list (list ))

(define (eat-dot x y)
  
  (place-image eaten_dot x y background)
   (append (list x y) coor-list))

(define (tick-pacman pm)
  (match pm
    [(pacman 30 y "left")
     (pacman 33 y "right")]
    [(pacman x y "left")
     ;; attempt to eat dot
     (if (and (check-eq? (cons x y) (cons c1 c2)) (not (member (list x y) coor-list))) 
              (eat-dot c1 c2)  (pacman (- x 3) y "left"))]
    [(pacman 580 y "right")
     (pacman 580 y "left")]
    [(pacman x y "right")
     (pacman (+ x 3) y "right")]
    [(pacman x 570 "down")
      (pacman x 570 "up")]
    [(pacman x y "down")
     (pacman x (+ y 3) "down")]
    [(pacman x 120 "up")
      (pacman x 120 "down")]
    [(pacman x y "up")
     (pacman x (- y 3) "up")]))

;;(module+ test
  ;;(check-equal?
   ;;(tick-ghost (ghost 20 10 "left"))
   ;;(ghost 18 10 "left")))

(define (tick-ghost gh)
  (match gh
   
     [(ghost x y "left")
     (ghost (- x 2) y "left")]
    [(ghost x y "right")
     (ghost (+ x 2) y "right")]
     [(ghost x 570 "down")
      (ghost x 570 "up")]
    [(ghost x y "down")
     (ghost x (+ y 2) "down")]
     [(ghost x 120 "up")
      (ghost x 120 "down")]
    [(ghost x y "up")
     (ghost x (- y 2) "up")]))


;; key


;;(module+ test
;;  (check-equal?
  ;; (key-game (game (pacman 20 10 "left") (ghost 40 30 "down")) "up")   
  ;; (game (pacman 20 10 "up") (ghost 40 30 "down"))))


;; Game KeyEvent -> Game
(define (key-game g ke)
  (match g
    [(game pm gh)
     (game (pacman-key pm ke) gh)]))


  
(module+ test
  (check-equal?
   (pacman-key (pacman 20 10 "left") "up")
   (pacman 20 10 "up")))

;; Pacman KeyEvent -> Pacman
(define (pacman-key pm ke)
  (match ke
    ["left" (match pm
     
              [(pacman x y dir)
               (pacman x y "left")])]
    ["right" (match pm
              [(pacman x y dir)
               (pacman x y "right")])]
    ["up" (match pm
              [(pacman x y dir)
               (pacman x y "up")])]
    ["down" (match pm
              [(pacman x y dir)
               (pacman x y "down")])]
    [_ pm]))


