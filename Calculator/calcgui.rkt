#lang racket/gui

(require "calculator.rkt")

;; basic calculator
(define (push-operation e)
  (send display$ set-value (string-append (send display$ get-value) e)))

(define (push-number button-value)
  (define current-display (send display$ get-value))
  (define result
    (match current-display
      [(regexp #rx"^0") button-value]
      [_ (string-append current-display button-value)]))
  (send display$ set-value result))

(define frame (new frame% [label "Calculator"]))

(define display$ (new text-field%
                      (label "")
                      (parent frame)
                      (init-value "0")))

(define row0 (new horizontal-panel% [parent frame]))
(new button% [parent row0]
     [label ""]
     [min-width 30]
     [enabled #f])
(new button% [parent row0]
     [label ""]
     [min-width 30]
     [enabled #f])
(new button% [parent row0]
     [label ""]
     [min-width 30]
     [enabled #f])
(new button% [parent row0]
     [label "R"]
     [min-width 30]
     [callback (λ (b e)
                 (send display$ set-value "0"))])

(define row1 (new horizontal-panel% [parent frame]))

(new button% [parent row1]
     [label "9"]
     [min-width 30]
     [callback (λ (button event)
                 (push-number "9"))])

(new button% [parent row1]
     [label "8"]
     [min-width 30]
     [callback (λ (button event)
                 (push-number "8"))])

(new button% [parent row1]
     [label "7"]
     [min-width 30]
     [callback (λ (button event)
                 (push-number "7"))])

(new button% [parent row1]
     [label "+"]
     [min-width 30]     
     [callback (λ (button event)
                 (push-operation "+"))])

(define row2 (new horizontal-panel% [parent frame]))

(new button% [parent row2]
     [label "6"]
     [min-width 30]     
     [callback (λ (button event)
                 (push-number "6"))])

(new button% [parent row2]
     [label "5"]
     [min-width 30]
     [callback (λ (button event)
                 (push-number "5"))])

(new button% [parent row2]
     [label "4"]
     [min-width 30]
     [callback (λ (button event)
                 (push-number "4"))])

(new button% [parent row2]
     [label "-"]
     [min-width 30]
     [callback (λ (button event)
                 (push-operation "-"))])

(define row3 (new horizontal-panel% [parent frame]))

(new button% [parent row3]
     [label "3"]
     [min-width 30]
     [callback (λ (button event)
                 (push-number (send button get-label)))])

(new button% [parent row3]
     [label "2"]
     [min-width 30]
     [callback (λ (button event)
                 (push-number "2"))])

(new button% [parent row3]
     [label "1"]
     [min-width 30]
     [callback (λ (button event)
                 (push-number "1"))])

(new button% [parent row3]
     [label "×"]
     [min-width 30]
     [callback (λ (button event)
                 (push-operation "*"))])

(define row4 (new horizontal-panel% [parent frame]))

(new button% [parent row4]
     [label "0"]
     [min-width 30]
     [callback (λ (button event)
                 (push-number "0"))])

(new button% [parent row4]
     [label "."]
     [min-width 30]
     [callback (λ (button event)
                 (push-number "."))])  

(new button% [parent row4]
     [label "="]
     [min-width 30]
     [callback (λ (b e)
                 (define expr (send display$ get-value))
                 (send display$ set-value (push-equal expr)))])

(new button% [parent row4]
     [label "÷"]
     [min-width 30]
     [callback (λ (button event)
                 (push-operation "/"))])

(send frame show #t)