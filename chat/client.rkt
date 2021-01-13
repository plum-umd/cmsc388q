#lang racket
;; A simple chat client

;; Two ways to run:
;;
;; - from the command line (see chat.rkt)
;;
;; - in DrRacket, press Run.  At the REPL type:
;;
;;      (start-chat Username Server-Address)
;;
;;   where Username is a String for the handle you'd like to use
;;   and Server-Address is a String for the server you'd like to
;;   connect to.  If the server is running locally on your machine,
;;   you can use LOCALHOST for the Server-Address.

;; NOTE: you'll need to have a server running, either on your machine
;; or somewhere else you can connect to, *before* you start the
;; client, if you want to actually communicate with the server.
;; See server.rkt.

(provide start-chat)
(require 2htdp/image
         2htdp/universe)

(module+ test (require rackunit))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Chat client

;; String String -> Chat
;; Start a chat client with given user and server name
(define (start-chat user srvr)
  (big-bang (chat user (line "" 0) '())
    [on-key     chat-press]
    [to-draw    chat-scene]
    [on-receive chat-recv-facade]
    [register   srvr]))



;; type char-rpc
(struct crpc (cmd from channel msg) #:prefab)

(define (chat-recv-facade c msg)
	(chat-recv c (entry (string-append (crpc-from msg) "@" (crpc-channel msg)) (crpc-msg msg)) )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Types

;; type Chat = (chat ID Line (Listof Entry))
(struct chat (user line entries) #:prefab)

;; type Entry = (entry ID String)
(struct entry (user str) #:prefab)

;; type Line = (line String Index)
(struct line (str i) #:prefab)

;; type ID = String

;; type Package = (make-package Chat Entry)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants

(define TEXT-SIZE 14)
(define MSG-COLOR "black")
(define USER-COLOR "purple")
(define HEIGHT (* TEXT-SIZE 30))
(define WIDTH  (* TEXT-SIZE 25))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Chat

(module+ test
  (define line0 (line "abc" 1))
  
  (check-equal? (chat-press (chat "DVH" line0 '()) "left")
                (chat "DVH" (left line0) '()))
  (check-equal? (chat-press (chat "DVH" line0 '()) "right")
                (chat "DVH" (right line0) '()))
  (check-equal? (chat-press (chat "DVH" line0 '()) "\b")
                (chat "DVH" (del line0) '()))
  (check-equal? (chat-press (chat "DVH" line0 '()) "\r")
                (make-package
                 (chat "DVH" (line "" 0) (list (entry "DVH" "abc")))
                 (entry "DVH" "abc")))
  (check-equal? (chat-press (chat "DVH" line0 '()) "z")
                (chat "DVH" (ins line0 "z") '()))
  (check-equal? (chat-press (chat "DVH" line0 '()) "f1")
                (chat "DVH" line0 '())))

;; type ChatPackage =
;; | Chat
;; | (make-package Chat Entry)

;; Chat KeyEvent -> ChatPackage
;; Press a key in given chat
(define (chat-press c ke)
  (match c
    [(chat user line entries)
     (match ke
       ["left"  (chat user (left  line)  entries)]
       ["right" (chat user (right line)  entries)]
       ["\b"    (chat user (del   line)  entries)]
       ["\r"    (newline c)]
       [_       (if (1string? ke)
                    (chat user (ins line ke) entries)
                    c)])]))

(module+ test
  (check-equal? (newline (chat "DVH" line0 '()))
                (make-package (chat "DVH" (line "" 0) (list (entry "DVH" "abc")))
                              (entry "DVH" "abc")))
  (check-equal? (newline (chat "DVH" line0 (list (entry "388Q" "sup"))))
                (make-package (chat "DVH" (line "" 0)
                                    (list (entry "DVH" "abc")
                                          (entry "388Q" "sup")))
                              (entry "DVH" "abc"))))




;; Chat -> ChatPackage
;; Commit current line to entries and start new line
(define (newline c)
  (match c
    [(chat user (line str i) entries)
   	
     (if (and (> (string-length str) 0) (equal? "/" (substring str 0 1)))	
	(handle_cmd c)
     	(make-package (chat user (line "" 0) entries) (crpc "send" user "" str))
     )

     ]))

(define (regex-call str rexp f) 
	(let ([m (regexp-match rexp str)])
	     (if (equal? m #f)
		 #f
		 (f m)
	     )
	)
)

(define (regex-loop str pair-list) 
	(if (null? pair-list)
		#f
		(let ([res (regex-call str (car (car pair-list)) (cdr (car pair-list))  )])
			(if (equal? res #f)
				(regex-loop str (cdr pair-list))
				res	
			)
		)
	)
)

(define (handle_cmd c)
	( match c [(chat user (line str i) entries) 
	(let
		([res 
			(regex-loop (line-str (chat-line c)) 
			(list 
				(cons
					 #rx"^/nick (.+)$" 
					(lambda (lst) (make-package (chat user (line "" 0) entries) (crpc "nick" (car (cdr lst)) "" "")) )
				)
				(cons	
					 #rx"^/msg ([^ ]+) (.+)$" 
					(lambda (lst) (make-package (chat user (line "" 0) entries) (crpc "send" "" (list-ref lst 1) (list-ref lst 2) )) )
				)
			))
		])
		(if (equal? res #f)
		    c
		    res
		) 
	)])
)
       
;; String -> Boolean
(define (1string? s)
  (= 1 (string-length s)))


(module+ test
  (check-equal? (chat-recv (chat "DVH" line0 '()) (list (entry "Bob" "Hi")))
                (chat "DVH" line0 (list (entry "Bob" "Hi"))))
  (check-equal? (chat-recv (chat "DVH" line0 '()) (entry "Bob" "Hi"))
                ; single entries are not expected and ignored
                (chat "DVH" line0 '()))
  (check-equal? (chat-recv (chat "DVH" line0 '()) (list (entry 9 "Hi")))
                ; bad entries are not expected and ignored
                (chat "DVH" line0 '()))
  (check-equal? (chat-recv (chat "DVH" line0 '()) 'junk)
                ; junk
                (chat "DVH" line0 '())))



;; Chat (Listof Entry) -> Chat
;; Receive a message from the server
(define (chat-recv c msg)
  (if (good-message? msg)
      (match c
        [(chat user line entries)
         (chat user line (append (list msg) entries))])
      ;; server sent us bad data
      c))


;(define (good-message? msg)
;  (and (list? msg)
;       (andmap (λ (e)
;                 (match e
;                   [(entry (? string?) (? string?)) #t]
;                   [_ #f]))
;               msg)))

(define (good-message? msg) #t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Visualize a Chat

;; Chat -> Image
(define (chat-scene c)
  (place-image/align (chat-draw c)
                     0 HEIGHT
                     "left" "bottom"
                     (empty-scene WIDTH HEIGHT)))

;; Chat -> Image
(define (chat-draw c)
  (match c
    [(chat user line entries)
     (above/align "left"
                  (draw-entries entries)
                  (draw-line line))]))

;; (Listof Entry) -> Image
(define (draw-entries es)
  (match es
    ['() empty-image]
    [(cons e es)
     (above/align "left"
                  (draw-entries es)
                  (draw-entry e))]))

;; Entry -> Image
(define (draw-entry e)
  (match e
    [(entry user str)
     (beside (text (string-append user "> ") TEXT-SIZE USER-COLOR)
             (text str TEXT-SIZE MSG-COLOR))]))

;; Line -> Image
(define (draw-line l)
  (match l
    [(line str i)
     (beside (text (string-append "> ") TEXT-SIZE USER-COLOR)
             (text (substring str 0 i) TEXT-SIZE MSG-COLOR)
             (rectangle 1 TEXT-SIZE "solid" "black")
             (text (substring str i) TEXT-SIZE MSG-COLOR))]))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Line

(module+ test
  (check-equal? (right (line "abc" 0)) (line "abc" 1))
  (check-equal? (right (line "abc" 1)) (line "abc" 2))
  (check-equal? (right (line "abc" 2)) (line "abc" 3))
  (check-equal? (right (line "abc" 3)) (line "abc" 3)))

;; Line -> Line
;; Move the cursor to the right
(define (right l)
  (match l
    [(line s i)
     (if (= i (string-length s))
         l
         (line s (add1 i)))]))

(module+ test  
  (check-equal? (left (line "abc" 0)) (line "abc" 0))
  (check-equal? (left (line "abc" 1)) (line "abc" 0))
  (check-equal? (left (line "abc" 2)) (line "abc" 1))
  (check-equal? (left (line "abc" 3)) (line "abc" 2)))

;; Line -> Line
;; Move the cursor to the left
(define (left l)
  (match l
    [(line s i)
     (if (= i 0)
         l
         (line s (sub1 i)))]))

(module+ test  
  (check-equal? (del (line "abc" 0)) (line "abc" 0))
  (check-equal? (del (line "abc" 1)) (line "bc"  0))
  (check-equal? (del (line "abc" 2)) (line "ac"  1))
  (check-equal? (del (line "abc" 3)) (line "ab"  2)))

;; Line -> Line
;; Move the cursor to the left
(define (del l)
  (match l
    [(line s i)
     (if (= i 0)
         l
         (line (string-append (substring s 0 (sub1 i)) (substring s i))
               (sub1 i)))]))

(module+ test  
  (check-equal? (ins (line "abc" 0) "z") (line "zabc" 1))
  (check-equal? (ins (line "abc" 1) "z") (line "azbc" 2))
  (check-equal? (ins (line "abc" 2) "z") (line "abzc" 3))
  (check-equal? (ins (line "abc" 3) "z") (line "abcz" 4)))

;; Line 1String -> Line
;; Insert a letter into line
(define (ins l c)
  (match l
    [(line s i)
     (line (string-append (substring s 0 i) c (substring s i))
           (add1 i))]))
