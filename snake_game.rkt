#lang racket
(require racket/gui)

(define BLOCK_SIZE 16)

(define WIDTH 40)
(define HEIGHT 40)

(define snake (list (list 2 1) (list 1 1)))

(define storage (list 9 8))

(define direction 'r)

(define first #t)

(define score 0)

(define (move-block x y) (reverse (append (cdr (reverse snake)) (list(list x y)))))

(define (snake-head position lst) (list-ref (list-ref lst 0) position))

(define (draw-block screen x y color) 
  (send screen set-brush color 'solid)
  (send screen draw-rectangle (* x BLOCK_SIZE) (* y BLOCK_SIZE) BLOCK_SIZE BLOCK_SIZE))

(define (move-snake position)
  (case position
    ['l (set! snake (move-block (- (snake-head 0 snake) 1) (snake-head 1 snake)))]
    ['r (set! snake (move-block (+ (snake-head 0 snake) 1) (snake-head 1 snake)))]
    ['u (set! snake (move-block (snake-head 0 snake) (- (snake-head 1 snake) 1)))]
    ['d (set! snake (move-block (snake-head 0 snake) (+ (snake-head 1 snake) 1)))]))

(define (touched-block snakes block [index 0] [x 666]) 
  (if (> (length snakes) index)
    (if (and (not (= x index)) (and 
      (eq? (list-ref (list-ref snakes index) 0) (list-ref block 0))
      (eq? (list-ref (list-ref snakes index) 1) (list-ref block 1)))) 
        #t
      (touched-block snakes block (+ index 1) x))
    #f))

(define expand-snake (lambda () 
  (define x (car (reverse snake)))
  (set! storage (list (inexact->exact (round (* (random) (- WIDTH 1)))) (inexact->exact (round (* (random) (- HEIGHT 1)))) ))
  (move-snake direction)
  (set! score (+ score 10))
  (set! snake (append snake (list x)))))

(define restart (lambda()
  (set! first #f)
  (set! direction 'r)
  (set! storage (list 9 8))
  (set! snake (list (list 2 1) (list 1 1)))
  (set! score 0)
))

(define start (lambda() (restart)))

(define frame (new frame% [label "Snake"] [width (* WIDTH BLOCK_SIZE)] [height (* HEIGHT BLOCK_SIZE)]))

; Defines the key to move the snake and start the game
(define (canvas-key frame) (class canvas%
  (define/override (on-char key-event)
    (cond
      [(eq? (send key-event get-key-code) 'left) (set! direction 'l)]
      [(eq? (send key-event get-key-code) 'right) (set! direction 'r)]
      [(eq? (send key-event get-key-code) 'up) (set! direction 'u)]
      [(eq? (send key-event get-key-code) 'down) (set! direction 'd)]
      [(eq? (send key-event get-key-code) '#\r) (restart)]
      [(eq? (send key-event get-key-code) '#\s) (start)]))
  (super-new [parent frame])))

;increases snake size
(define update-snake (lambda () 
  (draw-block screen (list-ref storage 0) (list-ref storage 1) "red")
  (cond [(touched-block snake storage) (expand-snake)] [else (move-snake direction)])
  (send screen draw-text "Score: " (- (* WIDTH BLOCK_SIZE) 120) 10)
  (send screen draw-text (number->string score) (-(* WIDTH BLOCK_SIZE) 50) 10)
  (for ([block snake]) (
    if (eq? block (car snake)) 
      (draw-block screen (list-ref block 0) (list-ref block 1) "green") 
      (draw-block screen (list-ref block 0) (list-ref block 1) "green")))))

;prints the Game Over message and tells user how to restart
(define game-over (lambda ()
  (if first (begin) (send screen draw-text "      Game Over!     " (- (round (/ (* WIDTH BLOCK_SIZE) 2)) 110) (- (round (/ (* HEIGHT BLOCK_SIZE) 2)) 40)))
  (if first 1 (send screen draw-text "(press r to restart)" (- (round (/ (* WIDTH BLOCK_SIZE) 2)) 100) (- (round (/ (* HEIGHT BLOCK_SIZE) 2)) 20)))
))

(define begin (lambda ()
  (send screen draw-text "  Welcome to Snake     " (- (round (/ (* WIDTH BLOCK_SIZE) 2)) 110) (- (round (/ (* HEIGHT BLOCK_SIZE) 2)) 40))
  (send screen draw-text "Expand the Screen First     " (- (round (/ (* WIDTH BLOCK_SIZE) 2)) 125) (- (round (/ (* HEIGHT BLOCK_SIZE) 2)) 20))
  (send screen draw-text "(press s to start)" (- (round (/ (* WIDTH BLOCK_SIZE) 2)) 100) (- (round (/ (* HEIGHT BLOCK_SIZE) 2)) 0))
))

;Creates a new screen
(define canvas (new (canvas-key frame)))

(define screen (send canvas get-dc))

(send screen set-font (make-object font% 12 'modern))
(send screen set-text-foreground "white")

(send frame show #t)

(define updater (new timer%
  [notify-callback (lambda ()
    (send screen clear)
    (send screen set-brush "black" 'solid)        
    (send screen draw-rectangle 0 0 (* WIDTH BLOCK_SIZE) (* HEIGHT BLOCK_SIZE))

    (define collision #f)

    (if first (set! collision #t) 1)
                 
    (for ([block snake]
         [j (in-naturals 0)])
      (cond 
            [(or (> (list-ref block 0) (- WIDTH 1)) (> 0 (list-ref block 0))) (set! collision #t )]
            [(or (> (list-ref block 1) (- HEIGHT 1)) (> 0 (list-ref block 1))) (set! collision #t)]
            [(eq? #f collision) (set! collision (eq? #t (touched-block snake block 0 j)))]))
    (if collision (game-over) (update-snake)))]
  [interval #f]))

(send updater start 100)