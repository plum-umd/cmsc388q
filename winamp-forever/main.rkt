#lang racket/gui

(require rsound "audio.rkt")

; A very simple audio player that allows opening a file  and playing it. Can pause and stop the
; audio. Only supports WAV format, because rsound only supports WAV. rsound is not suitable for
; this purpose, because it doesn't allow seeking or even pausing: once you start playing the
; file, you can only completely stop it. Therefore, clipping is used to replicate pausing.
; GStreamer is a great library that supports everything I need, but I could not make it work.
; My attempts to FFI GStreamer are in audio.rkt file. I think they are successful, I am just
; missing something about how GStreamer works when you start playing things. Music examples
; for testing are in "music" folder.


; state consists of
; audio: rsound - audio file that is currently playing
; current-position: int - current position in the audio that is currently playing, in milliseconds
; is-playing: bool - whether the audio is playing or not
; last-timestamp: int - the timestamp of the last time the user pressed "pause"
(struct state
  ([audio #:mutable]
   [current-position #:mutable]
   [is-playing #:mutable]
   [last-timestamp #:mutable]) #:prefab)


; initial state
(define STATE
  (state '() -1 #f -1))


; main window
(define frame
  (new frame% [label "Player"]))
 
; panel to position play and stop buttons on the same line
(define panel (new horizontal-panel% [parent frame]
                                     [alignment '(center center)]))

; play/pause button
; initially disabled, becomes enabled when a file is loaded
(define play-pause-button
  (new button% [parent panel] [label "Play"] [enabled #f]
       [callback (lambda (button event)
                   (if (state-is-playing STATE)
                       ; pausing
                       (begin
                         ; update position in the song - take current position, add the
                         ; diff between the last time play was pressed and right now
                         (set-state-current-position! STATE
                                                       (+
                                                        (- (current-milliseconds) (state-last-timestamp STATE))
                                                        (state-current-position STATE)))
                         (set-state-is-playing! STATE #f)

                         (send play-pause-button set-label "Play")
                 
                         (stop))
                       ; playing
                       (begin
                         (set-state-is-playing! STATE #t)
                         (set-state-last-timestamp! STATE (current-milliseconds))

                         (send play-pause-button set-label "Pause")

                         ; calculate current frame using the frame rate of the audio (frames per second)
                         (let ([current-frame (round (* (/ (rs-frame-rate (state-audio STATE)) 1000) (state-current-position STATE)))])
                           (play
                            ; starting from a certain position is achieved by cutting the audio's starting frames up to
                            ; a needed position
                            (clip
                             (state-audio STATE)
                             current-frame
                             (rs-frames (state-audio STATE))))))))]))
; stop button
(define stop-button
  (new button% [parent panel] [label "Stop"] [enabled #f]
       [callback (lambda (button event)
                   (set-state-current-position! STATE 0)
                   (set-state-is-playing! STATE #f)
                   (send play-pause-button set-label "Play")
                 
                   (stop)
                   )]))

; choose file button
; uses get-file dialog
(new button% [parent frame] [label "Choose File..."]
     [callback (lambda (button event)
                 ; allow only .wav files, as only those are supported
                 (let ([file-path (get-file #f #f #f #f #f '() '(("Wav files" "*.wav")))])
                   (with-handlers
                       ; usually happens if the format is unsupported or the file is broken
                       ([exn:fail? (lambda (e)
                                     (send text set-label "File could not be opened"))])
                     ; read the audio as rsound and set it in the state
                     (set-state-audio! STATE (rs-read file-path))
                     (set-state-current-position! STATE 0)
                     (send play-pause-button enable #t)
                     (send stop-button enable #t)
                     ; set the text label to be "Playing %file_name%"
                     (let-values ([(base filename must-be-dir?) (split-path file-path)])
                       (send text set-label (string-append "Playing " (path->string filename)))))))])

; informational text
(define text (new message% [parent frame]
                  [label "No file selected"]))
 
; show the player
(send frame show #t)

; TODO:
; - when the window is closed, the sound keeps playing
; - when the audio file ends, user has to press stop in order to play it again, should
;   be done automatically
; - figure out why GStreamer doesn't work and use it instead of rsound
