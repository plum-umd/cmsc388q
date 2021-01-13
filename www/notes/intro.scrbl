#lang scribble/manual
@(require "../utils.rkt")


@(require scribble/examples racket/sandbox)



@(define core-racket
  (parameterize ([sandbox-output 'string]
                 [sandbox-error-output 'string]
                 [sandbox-memory-limit 50])
    (make-evaluator 'racket)))

@(core-racket '(require racket/match))

@(define-syntax-rule (ex e ...)
  (filebox (emph "Racket REPL")
    (examples #:eval core-racket #:label #f e ...)))


@title[#:style '(toc unnumbered)]{Introduction to Racket}

Now that you have Racket installed, let's get a quick introduction.

You can run Racket in a few different ways, but probably the
easiest way to learn Racket is by programming within
DrRacket, the Racket IDE.

When you open up DrRacket for the first time it will tell
you to select a language. This is your first clue that
Racket is unlike languages you've seen so far because it's
not just a single language, but a whole ecosystem of
languages and tools for making new languages, all of which
can coexist and interoperate with each other. But to start,
we are going to be working with the Racket language. To do
this, select the option to choose the language based on the
text of the program and start your program with

@verbatim|{
#lang racket
}|

Now press the Run button.

You'll see the DrRacket split into two panes. The one on top
contains the @tt|{#lang racket}| bit, and the one below
shows some information about the version of Racket you are
using and displays a prompt (@tt{>}).

The prompt is for a ``read-eval-print loop'' (or REPL),
where you can type Racket expressions which will be read,
evaluated, and the result printed for you. Let's start
there.  Try typing some of the following:

@ex[
 (+ 1 2)
 (* 3 4)
 (* (+ 1 2) 4)
 (+ 1 2 3 4)
 (string-append "hello" "there")
 (string-append "goodbye" ", " "friend")
 (even? 7)
 (or (not (even? 7)) (odd? 0))
 ]

Look at these examples and take a moment to think about
what's going on. What's different from languages you are
used to? What role are parentheses playing? What is the
syntax for calling a function? What data types have you
discovered so far?  In answering these questions, you will
have taught yourself a significant chunk of Racket.

Let's do a few more examples.  Try to for a mental model
of what's going on.  Use your REPL to confirm, refute, and
refine your mental model.

@ex[
 (eval:error (+ 1 "two"))
 (define ten (+ 1 2 3 4))
 (* 2 ten)
 (define (goodbye friend)
   (string-append "goodbye, " friend))
 (goodbye "pal")
 (goodbye "Elliot")
 (eval:error (goodbye "Elliot" "Alderson"))
 (define (hello title name)
   (string-append "Hello, " title ". " name))
 (hello "Dr" "Racket")
 ]

OK, so what have we seen so far:

@itemlist[
 @item{three data types: strings, booleans, numbers}

 @item{the syntax for function application is @tt{(}
  followed by a function name, followed by arguments, followed
  by @tt{)}.}

 @item{the syntax for a variable definition is @tt{(define}
  followed by the variable name, follwed by an expression,
  followed by @tt{)}.}

 @item{the syntax for a function definition is @tt{(define
   (} followed by the function name, followed by the parameter
  names, followed by @tt{)} followed by an expression for the
  function body, which may refer to the parameter names,
  followed by @tt{)}.}

 @item{some functions expect their arguments to be of a
  certain type and will cause an error if inappropriate
  arguments are given.}

 @item{some functions expect a certain number of arguments
  and will cause an error if an inappropriate number of
  arguments are given.  (Some functions, like @racket[+], work
  on any number of arguments.}

 @item{there are some built-in functions like @racket[+],
  @racket[*], @racket[string-append], @racket[even?],
  @racket[odd?], @racket[or], and @racket[not].}
                                                          
 ]
  

Next we'll take a look at more of the language by relating it
to a langauge you may have already seen: OCaml.

        



