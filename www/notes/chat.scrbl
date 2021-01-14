#lang scribble/manual
@(require "../utils.rkt")
@(require (for-label (except-in 2htdp/image line)
                     (except-in 2htdp/universe left right)))

@(require (submod "../../chat/client.rkt" private))

@(require scribble/examples racket/sandbox)
@(require (except-in 2htdp/image line))


@(define core-racket
   (make-base-eval
    '(require racket/match)
    '(require 2htdp/image)
    '(require racket/math)))

@(define-syntax-rule (ex e ...)
  (filebox (emph "Racket REPL")
    (examples #:eval core-racket #:label #f e ...)))


@title[#:style '(toc unnumbered)]{Chatting with Myself and Others}

The @racket[big-bang] system can do more than just
animation. The ticking of time is just one of the several
different kinds of @emph{events} for which a
@racket[big-bang] program can react. Other kinds of events
include mouse events, keyboard events, and even network
events.

Let's explore how the @racket[big-bang] system works by
developing a program that reacts to some of these other kind
of events. We'll try to build a chat system. It may seem a
bit weird, but we'll start by designing a chat client where
there's no else we can chat with; just ourselves. Later,
we'll revise the design so that it works to communicate with
other people.

To start with, consider a simple chat program. Something
that might look like this:

@(define curr (line "netflix and chiill?" 15))
@(define msgs
   (list
    (entry "Bobby" "go play with your watch collection")
    (entry "Phil" "harsh but true")
    (entry "Jerry" "I'm not even dead yet")
    (entry "Jerry" "oh shut up John, you're not in the band")
    (entry "John" "your body is a wond...")               
    (entry "Bill" "just hanging")
    (entry "Jerry" "not much")
    (entry "Phil" "nada")
    (entry "Bobby" "sup")))
@(define chat0
   (chat "John"
         curr
         msgs))
@(scale 1.5 (chat-draw chat0))

Here there's a chat history which identifies each user and
the message they sent, listed in chronological order (so the
oldest is at the top). The user is typing their next message
at the prompt and there is a cursor indicating where they
are making edits to the text:

@(scale 1.5 (draw-line curr))

Should the user type backspace, the cursor will delete the
letter to the left of the cursor:

@(scale 1.5 (draw-line (del curr)))

Now they're happy with the message, so they hit enter, which
sends the message off and commits it to the chat history,
giving a fresh prompt for the next message:

@(scale 1.5 (chat-draw (chat "John" (line "" 0) (cons (entry "John" "netflix and chill?") msgs))))

OK, let's take an inventory of everything here. A chat
consists of a collection of previous messages, each of which
consists of a user name and the content of that message.
There can be an arbitrary number of previous messages.
There's also the current message being composed, which has
some content and a cursor.

Here's a potential data type definition for representing the
state of a chat program:

@#reader scribble/comment-reader
(racketblock
;; type Chat = (chat ID Line (Listof Entry))
(struct chat (user line entries) #:prefab)

;; type Entry = (entry ID String)
(struct entry (user str) #:prefab)

;; type Line = (line String Index)
(struct line (str i) #:prefab)

;; type ID = String
 )

Here's a representation of the chat we saw to begin with:

@racketblock[
 (chat "John"       
       (line "netflix and chiill?" 15)
       (list (entry "Bobby" "go play with your watch collection")
             (entry "Phil" "harsh but true")
             (entry "Jerry" "I'm not even dead yet")
             (entry "Jerry" "oh shut up John, you're not in the band")
             (entry "John" "your body is a wond...")               
             (entry "Bill" "just hanging")
             (entry "Jerry" "not much")
             (entry "Phil" "nada")
             (entry "Bobby" "sup")))
 ]

Designing the program top-down, we can design the main entry
point for the chat client:

@#reader scribble/comment-reader
(racketblock
;; String -> Chat
;; Start a chat client with given user
(define (start-chat user)
  (big-bang (chat user (line "" 0) '())
    [on-key     chat-press]
    [to-draw    chat-scene]))
)

Switch to a bottom-up view, let's focus in on the actions
that happen when editing the line. The user can delete the
letter to the left of the cursor (if there is one). They can
move the cursor left (if not already all the way to the
left). They can move the cursor right (if not already all
the way to the right). They can insert a single letter.

We can design a function for each of these tasks and write
unit tests:

@#reader scribble/comment-reader
(racketblock
(module+ test
  (check-equal? (right (line "abc" 0)) (line "abc" 1))
  (check-equal? (right (line "abc" 1)) (line "abc" 2))
  (check-equal? (right (line "abc" 2)) (line "abc" 3))
  (check-equal? (right (line "abc" 3)) (line "abc" 3)))

;; Line -> Line
;; Move the cursor to the right
(define (right l) ...)

(module+ test  
  (check-equal? (left (line "abc" 0)) (line "abc" 0))
  (check-equal? (left (line "abc" 1)) (line "abc" 0))
  (check-equal? (left (line "abc" 2)) (line "abc" 1))
  (check-equal? (left (line "abc" 3)) (line "abc" 2)))

;; Line -> Line
;; Move the cursor to the left
(define (left l) ...)

(module+ test  
  (check-equal? (del (line "abc" 0)) (line "abc" 0))
  (check-equal? (del (line "abc" 1)) (line "bc"  0))
  (check-equal? (del (line "abc" 2)) (line "ac"  1))
  (check-equal? (del (line "abc" 3)) (line "ab"  2)))

;; Line -> Line
;; Move the cursor to the left
(define (del l) ...)

(module+ test  
  (check-equal? (ins (line "abc" 0) "z") (line "zabc" 1))
  (check-equal? (ins (line "abc" 1) "z") (line "azbc" 2))
  (check-equal? (ins (line "abc" 2) "z") (line "abzc" 3))
  (check-equal? (ins (line "abc" 3) "z") (line "abcz" 4)))

;; Line 1String -> Line
;; Insert a letter into line
(define (ins l c) ...)
  )

From here, it's pretty easy to correctly define the functions:

@(racketblock
(define (right l)
  (match l
    [(line s i)
     (if (= i (string-length s))
         l
         (line s (add1 i)))]))

(define (left l)
  (match l
    [(line s i)
     (if (= i 0)
         l
         (line s (sub1 i)))]))

(define (del l)
  (match l
    [(line s i)
     (if (= i 0)
         l
         (line (string-append (substring s 0 (sub1 i)) (substring s i))
               (sub1 i)))]))

(define (ins l c)
  (match l
    [(line s i)
     (line (string-append (substring s 0 i) c (substring s i))
           (add1 i))]))
)

Now we can focus on the higher-level @racket[chat] structure
and keyboard input.  Again, let's write a signature and unit tests
first:

@#reader scribble/comment-reader
(racketblock
(module+ test
  (define line0 (line "abc" 1))
  
  (check-equal? (chat-press (chat "DVH" line0 '()) "left")
                (chat "DVH" (left line0) '()))
  (check-equal? (chat-press (chat "DVH" line0 '()) "right")
                (chat "DVH" (right line0) '()))
  (check-equal? (chat-press (chat "DVH" line0 '()) "\b")
                (chat "DVH" (del line0) '()))
  (check-equal? (chat-press (chat "DVH" line0 '()) "\r")
                (chat "DVH" (line "" 0) (list (entry "DVH" "abc"))))
  (check-equal? (chat-press (chat "DVH" line0 '()) "z")
                (chat "DVH" (ins line0 "z") '()))
  (check-equal? (chat-press (chat "DVH" line0 '()) "f1")
                (chat "DVH" line0 '())))

;; Chat KeyEvent -> Chat
;; Press a key in given chat
(define (chat-press c ke) ...)
)

And now the code:

@#reader scribble/comment-reader
(racketblock
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
  )

This relies on a helper function for handling when the user
presses enter, called @racket[newline]. This function adds
the current line to the chat history and resets the current
line to be blank. Here are the signature and tests:

@#reader scribble/comment-reader
(racketblock
(module+ test
  (check-equal? (newline (chat "DVH" line0 '()))
                (chat "DVH" (line "" 0) (list (entry "DVH" "abc"))))
  (check-equal? (newline (chat "DVH" line0 (list (entry "388Q" "sup"))))
                (chat "DVH" (line "" 0)
                      (list (entry "DVH" "abc")
                            (entry "388Q" "sup")))))

;; Chat -> Chat
;; Commit current line to entries and start new line
(define (newline c) ...)
)

And the code:

@#reader scribble/comment-reader
(racketblock
(define (newline c)
  (match c
    [(chat user (line str i) entries)
     (chat user
           (line "" 0)
           (cons (entry user str) entries))]))
)

All that remains is @racket[chat-scene] for rendering a chat
state into an image.

First, we define some constants so that it's easy to adjust the sizes
with a single point of control:

@(racketblock
(define TEXT-SIZE 14)
(define MSG-COLOR "black")
(define USER-COLOR "purple")
(define HEIGHT (* TEXT-SIZE 30))
(define WIDTH  (* TEXT-SIZE 25))
)

And now:

@#reader scribble/comment-reader
(racketblock
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
)

Now you can give it a spin, by running:

@(racketblock
(start-chat "You")
)

Of course, it's not very good chat program if you can't chat
with your friends.

