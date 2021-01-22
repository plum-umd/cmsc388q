#lang racket/gui

(require rsound)

(struct state
  ([audio #:mutable]
   [current-timestamp #:mutable]
   [is-playing #:mutable]
   [last-timestamp #:mutable]) #:prefab)


(define STATE
  (state '() -1 #f -1))


(define frame
  (new frame% [label "Player"]))
 
; Add a horizontal panel to the dialog, with centering for buttons
(define panel (new horizontal-panel% [parent frame]
                                     [alignment '(center center)]))
 
; Add Cancel and Ok buttons to the horizontal panel
(new button% [parent panel] [label "Play"]
     [callback (lambda (button event)
                 (if (not (state-is-playing STATE))
                     (begin
                       (set-state-is-playing! STATE #t)
                       (set-state-last-timestamp! STATE (current-milliseconds))
                       
                       (let ([current-frame (round (* (/ (rs-frame-rate (state-audio STATE)) 1000) (state-current-timestamp STATE)))])
                         (play (clip (state-audio STATE) current-frame (rs-frames (state-audio STATE))))))
                     #f
                 ))])
(new button% [parent panel] [label "Pause"]
     [callback (lambda (button event)
                 (set-state-current-timestamp! STATE (- (current-milliseconds) (state-last-timestamp STATE)))
                 (set-state-is-playing! STATE #f)
                 
                 (stop)
                 )])
(new button% [parent panel] [label "Stop"]
     [callback (lambda (button event)
                 (set-state-current-timestamp! STATE 0)
                 (set-state-is-playing! STATE #f)
                 
                 (stop)
                 )])

(new button% [parent frame] [label "Choose File..."]
     [callback (lambda (button event)
                 (let ([file-path (get-file #f #f #f #f #f '() '(("Wav files" "*.wav")))])
                   (set-state-audio! STATE (rs-read file-path))
                   (set-state-current-timestamp! STATE 0)
                   (let-values ([(base filename must-be-dir?) (split-path file-path)])
                     (send text set-label (~a "Playing " (path->string filename))))
                 ))])

(define text (new message% [parent frame]
                  [label "No file selected"]))
 
; Show the dialog
(send frame show #t)

; TODO
; - handle unsuccessful audio opening
