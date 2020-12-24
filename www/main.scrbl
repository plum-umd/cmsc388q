#lang scribble/manual
@(require scribble/core
	  scriblib/footnote
          scribble/decode
          scribble/html-properties
      	  "defns.rkt"
          "utils.rkt")

@(define dvh @link["https://www.cs.umd.edu/~dvanhorn/"]{David Van Horn})

@(define (blockquote . strs)
   (make-nested-flow (make-style "blockquote" '(command))
                     (decode-flow strs)))


@(define accessible
   (style #f (list (js-addition "js/accessibility.js")
                   (attributes '((lang . "en"))))))

@title[#:style accessible]{Functional Programming in Racket}

@image[#:scale 1/2 #:style float-right]{img/yall.png}
@larger{@emph{@courseno}}


@emph{Winter, @year}

@emph{Lectures: Tuesday, Thursday, & Friday, 10-11:30am EST, Extremely Online}

@emph{Professor: @dvh}

CMSC 388Q is an introduction to functional programming in Racket.  It
is a one-credit, winter semester course that is being offered at the
height of a global pandemic (well, the height @emph{for now}).  The
goal of this course will be to explore, play, and build things in the
Racket programming language ecosystem.  It is intended to be fun,
nonstressful, and engaging.


@tabular[#:style 'boxed 
         #:row-properties '(bottom-border ())
	 (list (list @bold{Staff} 'cont 'cont)
	       (list @bold{Name} @elem{@bold{E-mail}} @elem{@bold{Hours}})
	       (list @dvh "dvanhorn@cs.umd.edu" "TBD EST"))]
	       
@bold{Communications:} Discord. See ELMS for the invite link.

@bold{Assumptions:} This course assumes you know how to and enjoy
programming.  Some familiarity with functional programming is helpful.
If you've completed CMSC 330, then you're good.

@bold{Disclaimer:} All information on this web page is tentative and subject to
change. Any substantive change will be accompanied with an announcement to the
class via ELMS.

@include-section["syllabus.scrbl"]
@include-section["project.scrbl"]
@include-section["texts.scrbl"]
@include-section["notes.scrbl"]
