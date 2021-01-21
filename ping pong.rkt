#lang racket
(require 2htdp/image)
(require 2htdp/universe)
;;defines the ball and side pieces
(define ball (circle 20 "solid" "red"))
(define rect (rectangle 10 80 "solid" "black"))
;;input for number of points being played to
(print "How many points do you want to play to? ")
(define end (string->number (read-line)))
;;structure that keeps track of the xy cords of the ball, what is being added to those cords, y cords of the boxes, points of each player,
;; and what should be added to the y cords of each players box
(struct inf (x y mx my p1y p2y points1 points2 add1 add2))
(module* main #f
  (big-bang (inf 0 0 5 5 0 0 0 0 0 0)
    [on-draw pos]
    [on-key paddle]
    [on-release stop]
    [on-tick move 1/60]))

;;checks if either player has won, if so stop showing the game and display who won, otherwise display the game with score on the top
(define (pos i) (if (= (inf-points1 i) end) (overlay (text "Player 1 Won!" 50 "green") (empty-scene 1000 600 "white"))
                    (if(= (inf-points2 i) end) (overlay (text "Player 2 Won!" 50 "green") (empty-scene 1000 600 "white"))
                    (overlay/offset (text (number->string (inf-points1 i)) 30 "blue") 50 270
                                    (overlay/offset (text (number->string (inf-points2 i)) 30 "blue") -50 270
                                    (overlay/offset rect 495 (inf-p2y i)
                                (overlay/offset rect -495 (inf-p1y i) (overlay/offset ball (inf-x i) (inf-y i) (empty-scene 1000 600 "white")))))))))

;;if game is over, do nothing, if at either end of the game, call reset which resets the game and adds a point to the appropiate player
;;if the ball hits a paddle, ceiling, or roof bounce off
(define (move j) (define i (addp j))
        (if (or (= (inf-points1 i) end) (= (inf-points2 i) end)) i
        (if (or (<= (inf-x i) -480) (>= (inf-x i) 480)) (reset i)
        (if (and (and (<= (inf-y i) (+ (inf-p2y i) 40)) (>= (inf-y i) (- (inf-p2y i) 40))) (>= (inf-x i) 470))
            (inf (- (inf-x i) (inf-mx i)) (+ (inf-y i) (inf-my i)) (* -1 (inf-mx i)) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) (inf-add1 i) (inf-add2 i))
        (if (and (and (<= (inf-y i) (+ (inf-p1y i) 40)) (>= (inf-y i) (- (inf-p1y i) 40))) (<= (inf-x i) -470))
            (inf (- (inf-x i) (inf-mx i)) (+ (inf-y i) (inf-my i)) (* -1 (inf-mx i)) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) (inf-add1 i) (inf-add2 i))
        (if (or (<= (inf-y i) -280) (>= (inf-y i) 280))
            (inf (+ (inf-x i) (inf-mx i)) (- (inf-y i) (inf-my i)) (inf-mx i) (* -1 (inf-my i)) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) (inf-add1 i) (inf-add2 i))
        (inf (+ (inf-x i) (inf-mx i)) (+ (inf-y i) (inf-my i)) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) (inf-add1 i) (inf-add2 i))))))))

;;when appropiate key is pressed, start adding to the y cord of the box. only does this if it wont cause paddle to go off screen
(define (paddle i key)
  (match key
    ["w" (if (< (inf-p2y i) 260) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) (inf-add1 i) 15) i)]
    ["s" (if (> (inf-p2y i) -260) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) (inf-add1 i) -15) i)]
    ["up" (if (< (inf-p1y i) 260) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) 15 (inf-add2 i)) i)]
    ["down" (if (> (inf-p1y i) -260) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) -15 (inf-add2 i)) i)]
    [_ i]))
;;resets game and gives point to appropiate player
(define (reset i) (if (>= (inf-x i) 480) (inf 0 0 5 5 0 0 (inf-points1 i) (+ 1 (inf-points2 i)) 0 0)
                      (inf 0 0 5 5 0 0 (+ 1 (inf-points1 i)) (inf-points2 i) 0 0)))

;;when player lets go of appropiate key stop adding to the y cord of the boc
(define (stop i key)
  (match key
    ["w" (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) (inf-add1 i) 0)]
    ["s" (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) (inf-add1 i) 0)]
    ["up" (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) 0 (inf-add2 i))]
    ["down" (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) 0 (inf-add2 i))]
    [_ i]))

;;adds to the paddles height if it wont cause the box to go out of the screen
(define (addp i) (if (and (canAdd (inf-p1y i) (inf-add1 i)) (canAdd (inf-p2y i) (inf-add2 i)))
  (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (+ (inf-p1y i) (inf-add1 i)) (+ (inf-p2y i) (inf-add2 i))
                      (inf-points1 i) (inf-points2 i) (inf-add1 i) (inf-add2 i))
  (if (canAdd (inf-p1y i) (inf-add1 i)) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (+ (inf-p1y i) (inf-add1 i)) (inf-p2y i)
                      (inf-points1 i) (inf-points2 i) (inf-add1 i) (inf-add2 i))
  (if (canAdd (inf-p2y i) (inf-add2 i)) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (+ (inf-p2y i) (inf-add2 i))
                      (inf-points1 i) (inf-points2 i) (inf-add1 i) (inf-add2 i)) i))))

;;returns true if adding to the y cord wont cause the paddle to go off screen
(define (canAdd y add) (if (and (> (+ y add) -260) (< (+ y add) 260)) #t #f))