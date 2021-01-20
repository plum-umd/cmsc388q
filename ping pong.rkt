#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(define ball (circle 20 "solid" "red"))
(define rect (rectangle 10 80 "solid" "black"))

(print "How many points do you want to play to? ")
(define end (string->number (read-line)))

(struct inf (x y mx my p1y p2y points1 points2 add1 add2))
(module* main #f
  (big-bang (inf 0 0 5 5 0 0 0 0 0 0)
    [on-draw pos]
    [on-key paddle]
    [on-release stop]
    [on-tick move 1/60]))

(define (pos i) (if (= (inf-points1 i) end) (overlay (text "Player 1 Won!" 50 "green") (empty-scene 1000 600 "white"))
                    (if(= (inf-points2 i) end) (overlay (text "Player 2 Won!" 50 "green") (empty-scene 1000 600 "white"))
                    (overlay/offset (text (number->string (inf-points1 i)) 30 "blue") 50 270
                                    (overlay/offset (text (number->string (inf-points2 i)) 30 "blue") -50 270
                                    (overlay/offset rect 495 (inf-p2y i)
                                (overlay/offset rect -495 (inf-p1y i) (overlay/offset ball (inf-x i) (inf-y i) (empty-scene 1000 600 "white")))))))))

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

(define (paddle i key)
  (match key
    ["w" (if (< (inf-p2y i) 260) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) (inf-add1 i) 15) i)]
    ["s" (if (> (inf-p2y i) -260) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) (inf-add1 i) -15) i)]
    ["up" (if (< (inf-p1y i) 260) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) 15 (inf-add2 i)) i)]
    ["down" (if (> (inf-p1y i) -260) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) -15 (inf-add2 i)) i)]
    [_ i]))
(define (reset i) (if (>= (inf-x i) 480) (inf 0 0 5 5 0 0 (inf-points1 i) (+ 1 (inf-points2 i)) 0 0)
                      (inf 0 0 5 5 0 0 (+ 1 (inf-points1 i)) (inf-points2 i) 0 0)))

(define (stop i key)
  (match key
    ["w" (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) (inf-add1 i) 0)]
    ["s" (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) (inf-add1 i) 0)]
    ["up" (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) 0 (inf-add2 i))]
    ["down" (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (inf-p2y i) (inf-points1 i) (inf-points2 i) 0 (inf-add2 i))]
    [_ i]))

(define (addp i) (if (and (canAdd (inf-p1y i) (inf-add1 i)) (canAdd (inf-p2y i) (inf-add2 i)))
  (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (+ (inf-p1y i) (inf-add1 i)) (+ (inf-p2y i) (inf-add2 i))
                      (inf-points1 i) (inf-points2 i) (inf-add1 i) (inf-add2 i))
  (if (canAdd (inf-p1y i) (inf-add1 i)) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (+ (inf-p1y i) (inf-add1 i)) (inf-p2y i)
                      (inf-points1 i) (inf-points2 i) (inf-add1 i) (inf-add2 i))
  (if (canAdd (inf-p2y i) (inf-add2 i)) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (inf-p1y i) (+ (inf-p2y i) (inf-add2 i))
                      (inf-points1 i) (inf-points2 i) (inf-add1 i) (inf-add2 i)) i))))

  (define (canAdd y add) (if (and (> (+ y add) -260) (< (+ y add) 260)) #t #f))