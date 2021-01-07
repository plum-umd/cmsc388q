#lang racket/base
(require "client.rkt"
         racket/cmdline
         2htdp/universe)

;; Command line interface for starting the chat client

;; From the command line, run:
;;
;;    racket chat.rkt
;;
;; to launch a client with username $USER and LOCALHOST server, or:
;;
;;    racket chat.rkt --user Username --server Server-Address
;;
;; to specify the username and/or server.  For example:
;;
;;    racket chat.rkt --user Bob --server untyped.lambda-calcul.us
;;
;; will try to connect to the server at untyped.lambda-calcul.us,
;; chatting as Bob.

;; If you Run this program in DrRacket it will do the same thing as
;; racket chat.rkt.

;; NOTE: you'll need to have a server running, either on your machine
;; or somewhere else you can connect to, *before* you start the
;; client, if you want to actually communicate with the server.
;; See server.rkt.


;; Start a chat client based on command line arguments

(module* main #f
  (let ((user #f) (srvr #f))
    (command-line
     #:program "chat"
     #:once-any
     [("-u" "--user")   u "Chat user name"  (set! user u)]
     #:once-any
     [("-s" "--server") s "Server location" (set! srvr s)]
     #:args ()
     (start-chat (or user (getenv "USER") "me")
                 (or srvr LOCALHOST)))))