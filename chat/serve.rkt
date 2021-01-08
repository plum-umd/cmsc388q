#lang racket
(require 2htdp/universe)

;; A Very Simple broadcast server

;; We broadcast every message received to every other connection

;; Either run this from DrRacket by pressing run, or from the
;; command line with
;;
;;   racket serve.rkt

(module+ main
  (universe (cs '() '())
    [on-new new-chat-client]
    [on-msg recv-msg]))

;; state of the universe is
;; - a list of connected worlds, and
;; - a list of previously sent messages

;; type ChatServer = (cs (Listof IWorld) (Listof Entry))
(struct cs (iws history) #:prefab)

;; ChatServer IWorld -> ChatServer
(define (new-chat-client u iw)
  (match u
    [(cs iws history)
     (make-bundle (cs (cons iw iws) history)
                  (list (make-mail iw history))
                  '())]))

;; ChatServer IWorld Entry -> ChatServer
(define (recv-msg u iw msg)
  (match u
    [(cs iws history)
     (make-bundle (cs iws (cons msg history))
                  ;(send-to-everyone-except u msg iw)
                  (filter-map (λ (iw-to)
                                (and (not (iworld=? iw-to iw))
                                     (make-mail iw-to (list msg))))
                              iws)
                  '())]))
