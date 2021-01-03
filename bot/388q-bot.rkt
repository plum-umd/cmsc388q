#lang racket
(require racket-cord
         racket/sandbox)

;; A Discord Bot for 388Q that hosts an evaluator for trying out
;; Racket examples

(define USAGE
  #<<HERE
I currently support the following commands:
- !echo _msg_: I just echo _msg_ back.
- !eval _e_: I read, eval, and print the Racket expression _e_.
HERE
)

;; launch the bot client
(module* main #f  
  (define bot-token (getenv "BOT_TOKEN"))
  (define bot-client (make-client bot-token #:auto-shard #t))
  (debug-log)
  (on-event 'message-create bot-client handle-message-create)
  (start-client bot-client))

  
;; Client Message -> Void
;; The main bot behavior logic
(define (handle-message-create client message)
  (unless (string=? (user-id (message-author message)) ; no self-talk
                    (user-id (client-user client)))
    (cond
      [(mentions-me? message client)
       (http:create-message client
                       (message-channel-id message)
                       "" #:embed (about-me message))]
      [(string-prefix? (message-content message) "!eval ")
       (repl (λ (c) (respond client message c))
             (string-trim (message-content message)  "!eval " #:right? #f))]
      [(string-prefix? (message-content message) "!echo ")
       (respond client message
                (string-trim (message-content message) "!echo " #:right? #f))])))

(define self-portrait
  "https://media.discordapp.net/attachments/786607936595296260/795416546775269416/PXL_20201231_174106169.jpg")

;; Construct an embed object for "about me" message
(define (about-me message)
  `#hash((thumbnail . #hash((url . ,self-portrait)))
         (color . #x95B5E3)
         (description .
                      ,(format "Hi <@~a>, I'm the 388Q Bot!\n~a"
                               (user-id (message-author message))
                               USAGE))))

;; Make a new evaluator
(define (init-ev)
  (make-evaluator '(begin)))

;; The evaluator
(define ev (init-ev))

;; Eval str and send the result back as a string with send
;; If the evaluator crashes, it is restarted
;; (String -> Y) String -> Y
(define (repl send str)
  (define restart? #f)
  (send
   (string-append
    "```Scheme\n> " str "\n"
    (with-handlers ([exn:fail? (λ (exn)
                                 (when (exn:fail:sandbox-terminated? exn)
                                   (set! restart? #t))
                                 (format "```_error_: ~a" (exn-message exn)))])
      (string-append (to-string (ev str))  "```"))))
  (when restart?
    (set! ev (init-ev))
    (send (string-append "_Restarting evaluator; come at me bro!_\n"
                         "```" (banner) "```"))))

;; Convert a value to a string
;; Any -> String
(define (to-string v)
  (if (void? v)
      ""
      (~v v #:max-width 1900 #:limit-marker "...")))


(define (respond client message content)
  (http:create-message client
                       (message-channel-id message)
                       content))

;; Message Client -> Boolean
;; Does the message mention me (this client)?
(define (mentions-me? message client)
  (ormap (λ (u) (string=? (user-id u)
                          (user-id (client-user client))))
         (message-mentions message)))

;; Receive debugging log entries and print to stdout
(define (debug-log)
  (define dr (make-log-receiver discord-logger 'debug))
  (thread
   (thunk
    (let loop ()
      (let ([v (sync dr)])
        (printf "[~a] ~a\n"
                (vector-ref v 0)
                (vector-ref v 1)))
      (loop)))))
