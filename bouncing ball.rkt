#lang racket
(require 2htdp/image)
(require 2htdp/universe)
(define ball (circle 20 "solid" "red"))



(struct inf (x y mx my r g b))
(define width (string->number (read-line)))
(define height (string->number (read-line)))
(module* main #f
  (big-bang (inf 0 0 5 5 85 170 255)
    [on-draw pos]
    [on-tick move 1/60]))

(define (pos i) (overlay/offset (circle 20 "solid" (color (inf-r i) (inf-g i) (inf-b i) 255)) (inf-x i) (inf-y i) (empty-scene width height "white")))

(define (move j) (define i (colors j))
        (if (or (<= (inf-x i) (- 20 (/ width 2))) (>= (inf-x i) (- (/ width 2) 20)))
            (inf (- (inf-x i) (inf-mx i)) (+ (inf-y i) (inf-my i)) (* -1 (inf-mx i)) (inf-my i) (inf-r i) (inf-g i) (inf-b i))
        (if (or (<= (inf-y i) (- 20 (/ height 2))) (>= (inf-y i) (- (/ height 2) 20)))
            (inf (+ (inf-x i) (inf-mx i)) (- (inf-y i) (inf-my i)) (inf-mx i) (* -1 (inf-my i)) (inf-r i) (inf-g i) (inf-b i))
        (inf (+ (inf-x i) (inf-mx i)) (+ (inf-y i) (inf-my i)) (inf-mx i) (inf-my i) (inf-r i) (inf-g i) (inf-b i)))))

(define (colors i) (if (= (inf-r i) 255) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) 0 (+ 1 (inf-g i)) (+ 1 (inf-b i)))
                      (if (= (inf-g i) 255) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (+ 1 (inf-r i)) 0 (+ 1 (inf-b i)))
                      (if (= (inf-b i) 255) (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (+ 1 (inf-r i)) (+ 1 (inf-g i)) 0)
                      (inf (inf-x i) (inf-y i) (inf-mx i) (inf-my i) (+ 1 (inf-r i)) (+ 1 (inf-g i)) (+ 1 (inf-b i)))))))