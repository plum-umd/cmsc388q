#lang racket
(require 2htdp/universe)

;; A Very Simple broadcast server

;; We broadcast every message received to every other connection

;; Either run this from DrRacket by pressing run, or from the
;; command line with
;;
;;   racket serve.rkt

(universe '()
 [on-new (λ (u iw) (cons iw u))]
 [on-msg (λ (u iw msg)
           (make-bundle u
                        (filter-map (λ (iw-to)
                                      (and (not (iworld=? iw-to iw))
                                           (make-mail iw-to msg)))
                                    u)
                        '()))])
