#lang racket
(require 2htdp/universe 2htdp/image)

(define WIDTH 900)
(define HEIGHT 600)
(define HALF_WIDTH (quotient WIDTH 2))
(define HALF_HEIGHT (quotient WIDTH 2))
(define BACKGROUND (empty-scene WIDTH HEIGHT))
(define OPACITY_START_VALUE 128)

(define UFO (bitmap/file "ufo.png"))
(define UFO_WIDTH (image-width UFO))
(define UFO_HEIGHT (image-height UFO))
(define UFO_HALF_WIDTH (quotient UFO_WIDTH 2))
(define UFO_HALF_HEIGHT (quotient UFO_HEIGHT 2))
(define MAX_UFO_Y (- HEIGHT UFO_HALF_HEIGHT))
(define MAX_UFO_X (- WIDTH UFO_HALF_WIDTH))
(define MIN_UFO_X UFO_HALF_WIDTH)
(define UFO_Y_MOV 4)
(define UFO_X_MOV 3)

(define SMOKE_RADIUS 10)

(struct point (x y) #:transparent)
(struct smoke-circle (point opacity) #:transparent)
(struct world (ufo smoke-circles) #:transparent)

(define initial-state (world (point HALF_WIDTH (- UFO_HEIGHT))
                             '()))

(define (render-element element pos background)
  (place-image element
               (point-x pos)
               (point-y pos)
               background))

(define (render-ufo ufo-pos background)
  (render-element UFO ufo-pos background))

(define (smoke-circle-image smoke)
  (circle SMOKE_RADIUS
          "solid"
          (color 0 0 0 (smoke-circle-opacity smoke))))

(define (render-smoke smoke background)
  (render-element (smoke-circle-image smoke)
                  (smoke-circle-point smoke)
                  background))

(define (render-smoke-circles smokes background)
  (if (empty? smokes)
      background
      (render-smoke-circles (rest smokes)
                            (render-smoke (first smokes)
                                          background))))

(define (decrease-smoke-opacity smokes)
  (map (lambda (smoke)
         (smoke-circle (smoke-circle-point smoke)
                       (- (smoke-circle-opacity smoke) 3)))
       smokes))

(define (create-smoke-before-ufo position)
  (smoke-circle (point (point-x position)
                       (- (point-y position) UFO_HALF_HEIGHT))
                OPACITY_START_VALUE))

(define (render-scene current-status)
  (render-ufo (world-ufo current-status)
              (render-smoke-circles (world-smoke-circles current-status)
                                    BACKGROUND)))

(define (process-smokes smokes ufo-pos)
  (define filtered-smokes (filter (lambda (smoke)
                                    (positive? (smoke-circle-opacity smoke)))
                                  (decrease-smoke-opacity smokes)))
  (define point-y-mod (modulo (point-y ufo-pos) 25))

  (if (or (zero? point-y-mod)
          (= point-y-mod 1)
          (= point-y-mod 2)
          (= point-y-mod 3))
      (cons (create-smoke-before-ufo ufo-pos)
            filtered-smokes)
      filtered-smokes))

(define (max-ufo-height? ufo-pos)
  (>= (point-y ufo-pos)
     MAX_UFO_Y))

(define (max-ufo-x? ufo-pos)
  (>= (point-x ufo-pos)
      MAX_UFO_X))

(define (next-ufo-height ufo-pos)
  (cond [(max-ufo-height? ufo-pos) (point-y ufo-pos)]
        [(max-ufo-height? (point 0 (+ (point-y ufo-pos) UFO_Y_MOV))) MAX_UFO_Y]
        [else (+ (point-y ufo-pos) UFO_Y_MOV)]))

(define (next-scene current-status)
  (world (point (point-x (world-ufo current-status))
                (next-ufo-height (world-ufo current-status)))
         (process-smokes (world-smoke-circles current-status)
                         (world-ufo current-status))))

(define (move-to-right current-status)
  (define x (point-x (world-ufo current-status)))
  (define y (point-y (world-ufo current-status)))
  (if (>= (+ x UFO_X_MOV) MAX_UFO_X)
      current-status
      (world (point (+ x UFO_X_MOV) y)
             (world-smoke-circles current-status))))

(define (move-to-left current-status)
  (define x (point-x (world-ufo current-status)))
  (define y (point-y (world-ufo current-status)))
        
  (if (<= (- x UFO_X_MOV) MIN_UFO_X)
      current-status
      (world (point (- x UFO_X_MOV) y)
             (world-smoke-circles current-status))))

(define (key-handler current-status pressed-key)
  (cond
    [(or (key=? pressed-key "left")
         (key=? pressed-key "a"))
     (move-to-left current-status)]
    [(or (key=? pressed-key "right")
         (key=? pressed-key "d"))
     (move-to-right current-status)]
    [else current-status]))

(define (is-final-scene? current-status)
  (and (empty? (world-smoke-circles current-status))
       (max-ufo-height? (world-ufo current-status))))

(define (main)
  (big-bang initial-state
    (on-tick next-scene)
    (stop-when is-final-scene?)
    (on-key key-handler)
    (to-draw render-scene)))

(main)
