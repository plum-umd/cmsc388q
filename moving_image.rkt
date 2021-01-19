#lang racket

#|working on creating an animation where an image is controlled by arrow keys
resources: Realm of Racket, Racket image documentation, and stack overflow (https://stackoverflow.com/questions/14540119/on-key-in-racket)
|#

(require 2htdp/image)
(require 2htdp/universe)


(module* main #f
  (big-bang (cons 250 250 )
    
    [on-draw spaceship-image]
   
    [on-key move]

    [stop-when out-of-space last-scene]

    ))


#|(define spaceship
  (bitmap/url "https://www.cs.umd.edu/class/winter2021/cmsc388Q/shipBlue_manned.png"))
|#




(define (move current-state key)

  (match key
    
   ["left" (cons (- (car current-state) 10 ) (cdr current-state))]
   
   ["right" (cons (+ (car current-state) 10) (cdr current-state))]
   
   ["up" (cons (car current-state) (- (cdr current-state) 10))]
   
   ["down" (cons (car current-state) (+ (cdr current-state) 10))]
   
   [_ current-state]))
   
 
(define (spaceship-image current-state)
  (place-image (star 20 "solid" "yellow")
               (car current-state)
               (cdr current-state)
               (empty-scene 500 500 "light blue"))
  )


(define (out-of-space current-state)
  (or  (>= (car current-state) 500)
       (>= (cdr current-state) 500)
       (<= (car current-state) 0)
       (<= (car current-state) 0)

       )
  )


(define (last-scene current-state)
    (place-image (above/align "center"
                 (text "update program to see further :(((" 14 "black")
                 (star-polygon 5 5 3 "outline" "yellow"))
                 250 250
                 (empty-scene 1000 1000 "light blue"))
  )
