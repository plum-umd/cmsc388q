#lang racket

(require math/array)

; size of our array
(define n 5)

; initialize data
(define data '(5 2 3 1 4))
(define next_data '(5 2 3 1 4))
(define goal '(1 2 3 4 5))

; gets tail of list without index, unique list
(define (tail-list e arr)
  (list-tail arr (index-of arr e))
)

; gets head of list without index, unique list
(define (head-list e arr)
  (reverse (tail-list e (reverse arr)))
)


; h(x) = inversion count of array (how close it is to sorted)
; inversion count function
; used the python code as a reference from
; https://www.geeksforgeeks.org/counting-inversions/
(define (invCount arr)
  (foldl (lambda (ei result)
           (+ result (foldl (lambda (ej tempResult)
                       (if (> ei ej) (+ tempResult 1) tempResult)
                       )
                     0 (tail-list ei arr)
                     )
              )
           ) 0 arr)
  )


; returns a shuffled mutation arr to test
(define (mutate arr) (shuffle arr))

; decides if the next_mutation was better than current
(define (selection arr)
  (define next_data (mutate arr))
  
  (define cur_h (invCount arr))
  (define next_h (invCount next_data))

  (if (< next_h cur_h) next_data arr)
 )

; run main data
(define (main arr)
  (define cur_count (invCount arr))
  (print cur_count)
  (if (> cur_count 0) (main (selection arr)) arr)
  )
  



