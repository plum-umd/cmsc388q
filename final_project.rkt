#lang racket
(require 2htdp/image 2htdp/universe)
(require 2htdp/planetcute)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Types

;type boy = (position-x position-y)
(struct boy (x y))

;;type boy-attack = (position-x position-y
(struct boy-attack (x y))

;;type bug-attack = (position-x position-y)
(struct bug-attack (x y))

;type bug = (posistion-x position-y)
(struct bug (x y))

;type heart = (position-x position-y)
(struct life (x y))

;type game =(boy (Listof bug-attack) (Listof bugs) (Listof bug-attacks) (Listof lives))
(struct game (boy boy-attacks bugs bug-attacks lives))



;;inspired by stack function from https://docs.racket-lang.org/teachpack/2htdpPlanet_Cute_Images.html?q=big-bang
;;create a x*y background image
(define (background x y)    
  (cond
    [(zero? y) empty-image]
    [(even? y) (overlay/xy  (background-row (make-list x wall-block)) 0 125 (background x (- y 1)))]
    [else (overlay/xy  (background-row (make-list x stone-block)) 0 125 (background x (- y 1)))]
    ))

;;referencing the draw-entries function from lecture code client.rkt
;;(Listof image) -> Image 
(define (background-row eles)
  (match eles
    ['() empty-image]
    [(cons ele eles)
     (beside ele (background-row eles  ))]))


;; Constants
;; crop image to make collision calculation more precise
(define WIDTH 14)
(define HEIGHT 7)
(define THRESH-HOLD-BUG 30)
(define THRESH-HOLD-BOY 40)
(define BLOCK-WIDTH (image-width stone-block))
(define MY-BUG  (crop 0 45 60 40 (scale 0.6 enemy-bug)))
(define boy-attack-img (crop 0 20 30 25 (scale 0.3 yellow-star)))
(define bug-attack-img (crop 0 40 60 50 (scale 0.6 rock)))
(define heart-img (scale 0.3 heart))
(define boy-img (crop 10 60 80 80 character-boy))


;;image-height of each block is 171, overlay is 125, use crop to remove unneccesary black section
(define background-img  (freeze(crop  0 46 (* BLOCK-WIDTH WIDTH) (* 125 HEIGHT) (background WIDTH HEIGHT))))

;;initialize a list of bugs when the game start
;;
(define (build-bug-list)
  (append (build-list HEIGHT (lambda (x) (bug 40 (+ 40 (* x 125)))))
          (build-list HEIGHT (lambda (x) (bug 100 (+ 40 (* x 125)))))
          (build-list HEIGHT (lambda (x) (bug 160 (+ 40 (* x 125)))))))

;;representation of a game to begin:
(define mygame (game (boy 1350 400)
                     '()
                     '()
                     '()
                     (list (life 1290 10)
                           (life 1260 10)
                           (life 1230 10))))


;game -> image
(define (draw-game g)
  (match g
    [(game boy boy-attacks bugs bugs-attacks lives)
     (draw-single-element boy
     (draw-list-of-elements lives 
     (draw-list-of-elements bugs-attacks
     (draw-list-of-elements boy-attacks
     (draw-list-of-elements bugs background-img)))))]))

(define (draw-list-of-elements eles bg-img)
  (match eles
    ['() bg-img]
    [(cons ele eles)
     (draw-single-element ele (draw-list-of-elements eles bg-img ))]))
  

(define (draw-single-element e bg-img)
  (match e
    [(bug x y)
     (place-image MY-BUG x y bg-img)]
    [(boy-attack x y )
     (place-image boy-attack-img x y bg-img)]
    [(bug-attack x y )
     (place-image bug-attack-img x y bg-img)]
    [(life x y )
     (place-image heart-img x y bg-img)]
    [(boy x y)
     (place-image boy-img x y bg-img)]))

;; referencing good-message function from lecture 
(define (move eles)
  (map(λ (e)
        (match e
          [(boy-attack x y) (boy-attack ( - x 10)  y)]
          [(bug x y) (bug ( + x 2) y)]
          [(bug-attack x y) (bug-attack ( + x 30)  y)]
          )) eles ))


(define (collision-check g)
  (match g
    [(game boy boy-attacks bugs bugs-attacks lives)
     (game boy
           (remove-ele boy-attacks bugs)
           (remove-ele bugs boy-attacks)
           (remove-ele bugs-attacks (cons boy '()))
           (update-lives bugs boy (update-lives bugs-attacks boy lives)))]
    ))

(define (update-lives bas b ls)
  (match ls
    ['() '()]
    [(cons heart hearts)
     (if (any-collided? b bas)
         hearts
         ls
         )]))
         
      
(define (remove-ele list-of-ele-to-check list-to-check-against)
  (filter (λ (e) ( not (any-collided? e list-to-check-against))) list-of-ele-to-check)
  )

(define (any-collided? ele-to-be-check list-to-check-against)
  (ormap (λ (e) (is-collided? ele-to-be-check e)) list-to-check-against))


;;using distance formula sqrt((x2 - x1)^2 + (y2-y1)^2))
(define (is-collided? attack-ele attacked-ele)
  (match attack-ele
    [(boy-attack x1 y1)
     (match attacked-ele
       [(bug x2 y2)
        (if (< (sqrt (+ (sqr (- x2 x1)) (sqr (- y2 y1)) ) ) THRESH-HOLD-BUG)
            #t
            #f)])]
    [(bug x1 y1)
     (match attacked-ele
       [(boy-attack x2 y2)
        (if (< (sqrt (+ (sqr (- x2 x1)) (sqr (- y2 y1)) ) ) THRESH-HOLD-BUG)
            #t
            #f)])]
    [(boy x1 y1)
     (match attacked-ele
       [(bug-attack x2 y2)
        (if (< (sqrt (+ (sqr (- x2 x1)) (sqr (- y2 y1)) ) ) THRESH-HOLD-BOY)
            #t
            #f)]
 
     
       [(bug x2 y2)
        (if (< (sqrt (+ (sqr (- x2 x1)) (sqr (- y2 y1)) ) ) THRESH-HOLD-BOY)
            #t
            #f)])]
    [(bug-attack x1 y1)
     (match attacked-ele
       [(boy x2 y2)
        (if (< (sqrt (+ (sqr (- x2 x1)) (sqr (- y2 y1)) ) ) THRESH-HOLD-BOY)
            #t
            #f)])])
  )
;;randomly generate a new bug with position x = 40 and random y
;;with 10% of chance
(define (generate-new-bug bugs)
  (if (< (random 100) 10)
      (cons (bug  40 (random 800)) bugs)
      bugs))
;; check if there is any bug created if so generated attack
(define (generate-new-bug-attack bugs bugs-attacks)
  (if (= (length bugs) 0)
      '()
      (generate-bug-atatck bugs bugs-attacks)))
     
  
;;randomly choose a bug from the list of bugs
;;with 10% of chance, create a new bug attack with bugs position
(define (generate-bug-atatck bugs bugs-attacks)
  (define rand-bug (list-ref bugs (random (length bugs))))
  (if (< (random 100) 10)
      (match rand-bug
        [(bug x y)
         (cons (bug-attack (+ x 60) y) bugs-attacks )])
      bugs-attacks))
  
(define (update-game g)
  (match (collision-check g)
    [(game boy boy-attacks bugs bugs-attacks lives)
     (game boy (move boy-attacks) (generate-new-bug (move bugs)) (generate-new-bug-attack bugs (move bugs-attacks)) lives)])
  )
(define (key-press g ke)
  (match g
    [(game boy boy-attacks bugs bugs-attacks lives)
     (match ke
       ["up" (game (up boy) boy-attacks bugs bugs-attacks lives)]
       ["down" (game (down boy) boy-attacks bugs bugs-attacks lives)]
       [" " (game boy (new-attack boy boy-attacks) bugs bugs-attacks lives)]
       [_ g]
       )]))
(define (up b)
  (match b
    [(boy x y)
     (if ( < y 20)
         b
         (boy x (- y 10)))]))

(define (down b)
  (match b
    [(boy x y)
     (if ( > y 790)
         b
         (boy x (+ y 10)))]))

(define (new-attack b boy-attacks)
  (match b
    [(boy x y)
     (cons (boy-attack x y) boy-attacks) ]))
(define (game-over? g)
  (match g
    [(game boy boy-attacks bugs bugs-attacks lives)
     (= (length lives) 0)]))

(define (last-picture g)
  (overlay (text "Game Over" 60 "black") background-img))
(big-bang mygame
  [to-draw draw-game]
  [on-tick update-game 1/28]
  [on-key key-press]
  [stop-when game-over? last-picture])