#lang racket
(require 2htdp/image)
;;struct that keeps track of the x and y cord of the box, score, if the box has already been clicked, and time passed
(struct game (x y score clk time))

;; starts game at a random location
(module* main #f
  (big-bang (game (random -275 275) (random -275 275) 0 #t 0)
    [on-draw spin]
    [on-tick endG 0.1 100]
    [on-mouse move]))
;;defines what a box is
(define box (square 50 "solid" "red"))

;;sets at which time the box changes to a new random location
(define (endG i) (if (= 10 (game-time i))(game (random -275 275) (random -275 275) (game-score i) #t (+ 1 (game-time i)))
                     (if (= 20 (game-time i)) (game (random -275 275) (random -275 275) (game-score i) #t (+ 1 (game-time i)))
                         (if (= 28 (game-time i)) (game (random -275 275) (random -275 275) (game-score i) #t (+ 1 (game-time i)))
                         (if (= 36 (game-time i)) (game (random -275 275) (random -275 275) (game-score i) #t (+ 1 (game-time i)))
                         (if (= 44 (game-time i)) (game (random -275 275) (random -275 275) (game-score i) #t (+ 1 (game-time i)))
                         (if (= 51 (game-time i)) (game (random -275 275) (random -275 275) (game-score i) #t (+ 1 (game-time i)))
                         (if (= 58 (game-time i)) (game (random -275 275) (random -275 275) (game-score i) #t (+ 1 (game-time i)))
                         (if (= 65 (game-time i)) (game (random -275 275) (random -275 275) (game-score i) #t (+ 1 (game-time i)))
                         (if (= 72 (game-time i)) (game (random -275 275) (random -275 275) (game-score i) #t (+ 1 (game-time i)))
                         (if (= 79 (game-time i)) (game (random -275 275) (random -275 275) (game-score i) #t (+ 1 (game-time i)))
                         (if (= 85 (game-time i)) (game (random -275 275) (random -275 275) (game-score i) #t (+ 1 (game-time i)))
                         (if (= 91 (game-time i)) (game (random -275 275) (random -275 275) (game-score i) #t (+ 1 (game-time i)))
                         (game (game-x i) (game-y i) (game-score i) (game-clk i) (+ (game-time i) 1)))))))))))))))


;; display box at the random location, if times up display your score
(define (spin i)
  (if (<= (game-time i) 99) (overlay/offset box (game-x i) (game-y i) (empty-scene 600 600 "white"))
      (overlay (text (string-append "You scored: " (number->string (game-score i))) 22 "red") (empty-scene 600 600 "white"))))

(require 2htdp/universe)


;; when mouse button is clicked checks to see if its within the bounds of the box and hasnt already been clicked, if so adds a point
(define (move i x y event)
  (match event
    ["button-down" (if (game-clk i)(if (and (and (> x (- 275 (game-x i))) (< x (- 325 (game-x i))))
                                                                       (and (> y (- 275 (game-y i))) (< y (- 325 (game-y i)))))
                                                                       (game (game-x i) (game-y i) (+ (game-score i) 1) #f (game-time i)) i) i)]
    [_ i]))