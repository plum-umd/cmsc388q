#lang racket
;; A chat bot

(require 2htdp/universe
         2htdp/image)

(struct entry (user str) #:prefab)

(define (main)
  (big-bang #f
    [to-draw bot-scene]
    [on-receive bot-respond]
    [register LOCALHOST]))

(define (bot-scene w)
  (bitmap/url
   "https://www.cs.umd.edu/class/winter2021/cmsc388Q/shipPink_manned.png"))

(define (bot-respond w es)
  (match es
    [(list e)
     (make-package #f
                   (entry "BotMcBotFace"
                          (string-append "Oh really?  "
                                         "Why do you say \""
                                         (entry-str e)
                                         "\"?")))]
    [_ #f]))