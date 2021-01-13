#lang racket
(require 2htdp/universe)

;; A Very Simple broadcast server

;; We broadcast every message received to every other connection

;; Either run this from DrRacket by pressing run, or from the
;; command line with
;;
;;   racket serve.rkt

(module+ main
  (universe (cs (make-isom) (make-hash '()) )
   [on-new new-chat-client]
    [on-msg recv-msg]))

;; state of the universe is
;; - a list of connected worlds, and
;; - a list of previously sent messages

;; type ChatServer = (cs (Map world->nick) (chan -> listof users))
(struct cs (usr chans) #:prefab)

;; type chat-rpc = (crpc (cmd from channel msg))
(struct crpc (cmd from channel msg) #:prefab)

(define (crpc-valid? s)
	(and (crpc? s) (string? (crpc-cmd s)) (string? (crpc-from s))
	      (string? (crpc-channel s)) (string? (crpc-msg s))   )
)

;; ChatServer IWorld -> ChatServer
(define (new-chat-client u iw)
  	(make-bundle u (list (make-mail iw (crpc "send" "" "" "Welcome to the server")))  '() )
)

;; Isomorphisms - used to store one-to-one data
(struct isom (dom codom))
(define (make-isom) (isom 
			(make-hash '()) 
		    	(make-hash '())
		     )
)

(define (isom-set! i d c)
	(if (hash-has-key? (isom-dom i) d)
	    (hash-remove! (isom-codom i) (hash-ref (isom-dom i) d))
	    (void))

	(hash-set! (isom-dom i) d c)
	(hash-set! (isom-codom i) c d)
)


(define (isom-ref i d) (hash-ref (isom-dom i) d))
(define (isom-ref! i d to-set) (hash-ref! (isom-dom i) d to-set))


(define (isom-ref-inv i c) (hash-ref (isom-codom i) c))
(define (isom-ref-inv! i c to-set) (hash-ref! (isom-codom i) c to-set))
(define (isom-has-key? i d) (hash-has-key? (isom-dom i) d))
(define (isom-has-key-inv? i c) (hash-has-key? (isom-codom i) c))

;; ChatServer IWorld Entry -> ChatServer
(define (recv-msg u iw msg)
	(if (crpc-valid? msg)
		; valid command, try to process
		(
			match (crpc-cmd msg)
			["nick" (handle-nick u iw msg)]
			["send" (handle-send u iw msg)]
			[_ (error-bundle u iw "Invalid command")]
		)
		; invalid command, inform the sender
		(error-bundle u iw "Invalid message format")
	)	
)

(define (error-bundle u iw err)
	 (make-bundle u (list (make-mail iw (crpc "error" "" "" (string-append "Error: " err) ) )) '() )
)

;handlers for commands

; assumes msg is valid
; nick command, the users new nick should be set in the from part of the msg
(define (handle-nick u iw msg) 
	(if     (or
			(< (string-length (crpc-from msg)) 1)
			(equal? "#" (substring (crpc-from msg) 0 1)) 
			(isom-has-key-inv? (cs-usr u) (crpc-from msg))
		)
	    (error-bundle u iw "Bad nickname")
	    (let ([_ (isom-set! (cs-usr u) iw (crpc-from msg))]) 
		(make-bundle u (list (make-mail iw (crpc "send" "" "" "Nick registered" ) )) '() )
            )
	)
)


(define (create-send-list u iw dest)
	(if (non-empty-string? dest)
	    (if (eq? "#" (substring dest 0 1))
		;send to channel
		(hash-ref (cs-chans u) dest (lambda () '()) )
		;send to user
		(if (isom-has-key-inv? (cs-usr u) dest)
			(list iw (isom-ref-inv (cs-usr u) dest))
			(list iw)
		)
	    )
	    ;send to global channel
	    (hash-keys (isom-dom (cs-usr u)))
	)
)

(define (handle-send u iw msg) 
	;check preconditions 
	(if (isom-has-key? (cs-usr u) iw)
	    (make-bundle u 
		
		( map (lambda (x) 
		      	(make-mail x (crpc "send" (isom-ref (cs-usr u) iw) (crpc-channel msg) (crpc-msg msg)) )
		      )
			(create-send-list u iw (crpc-channel msg) )
		)
		 '()
	    ) 
	
	    (error-bundle u iw "could not send")
	)
)
