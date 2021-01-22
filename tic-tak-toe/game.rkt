#lang racket/base
(require 2htdp/image)
(require 2htdp/universe)
(require racket/match)
(require string-util)
(require match-string)
(require dyoo-while-loop)

(define size 120)
(define font 75)

(define X
  (text "X" font "black"))

(define O
  (text "O" font "black"))

(define H
  (rectangle size 5 "solid" "black"))
; Horizontal Line
(define V
  (rectangle 5 size "solid" "black"))
; Vertical Line

(define WH
  (rectangle size 5 "solid" "white"))    ; Used for balnk boxes later to garuante spacing

(define WV
  (rectangle 5 size "solid" "white"))


(struct Game (image string ))


(define Box
  (above/align "right"
    (overlay/align "right" "center"
     (above/align "left" H  V) V) H ))

(define WBox
  (above/align "right"
    (overlay/align "right" "center"
      (above/align "left" WH  WV) WV) WH ))

(define BoardBlank
  (above
   (beside (beside Box Box) Box)
   (above (beside (beside Box Box) Box)
    (beside (beside Box Box) Box))))

(define Board_temp
  (above BoardBlank
         (beside
          (beside
           (overlay/align "center" "top" WBox (text "1" 25 "black"))
           (overlay/align "center" "top" WBox (text "2" 25 "black")))
          (overlay/align "center" "top" WBox(text "3" 25 "black")))))

(define Board
  (beside Board_temp
          (above
           (above
            (overlay/align "left" "top" WBox (text "  A" 25 "black"))
            (overlay/align "left" "top" WBox (text "  B" 25 "black")))
           (overlay/align  "left" "top" WBox (text "  C" 25 "black"))) ))


(define (keyHandler state key)
  (match state
    [(Game Board key)(if (equal? "x" key)
     (Game (overlay/align "left" "top" Board  (input X)) "x" )
     (Game (overlay/align "left" "top" Board  (input O)) "o" ))]))

(define (input key  ) (let ([input (read-line (current-input-port) 'any)])
  (if (not (= (string-length input) 2)) (print "Invalid Input (lowercaseletterNumber")
  (let  ( [ row (substring-trim-spaces input 0 1)])
    (let ( [ col (substring-trim-spaces (string-append input " ") 1 2)])
      (match row
        [(var r)  #:when (or (equal? row "a") (or (equal? row "b") (equal? row "c")))
                  (match col
                    [(var c) #:when (or (equal? col "3") (or (equal? col "2" )(equal? col "1"))) (update r   c key )]
                    [_ (print "Invalid Column Input")])]
        [_ (print "Invaid Row Input")] ;; HOw to make them go agains?
        ))))))


(define (update r c key )
  (match r
    [(var a) #:when (equal? r "a")  (overlay/align "left" "top" BoardBlank (updatehelp c key)) ]
    [(var a) #:when (equal? r "b")  (overlay/align "left" "center" BoardBlank (updatehelp c key))]
    [(var a) #:when (equal? r "c")  (overlay/align "left" "bottom" BoardBlank (updatehelp c key))]
  ))
(define (updatehelp c key)
  (match c
    [(var a) #:when (equal? c "1")
                 (let ([vis (beside ( beside (overlay key WBox) WBox) WBox)]) vis )]
    [(var a) #:when (equal? c "2")
                 (let ([vis (beside ( beside  WBox (overlay key WBox)) WBox)]) vis)]
    [(var a) #:when (equal? c "3")
                 (let ([vis (beside ( beside  WBox WBox) (overlay key WBox))])  vis  )]
   ))

 

(define (test x)
  (match x
    [(Game Board key )Board])
  )

(big-bang (Game Board "x" )
    [on-key    keyHandler]
    [to-draw    test ]
   
    )