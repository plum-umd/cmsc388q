#lang scribble/manual
@(require "../utils.rkt")
@(require (for-label 2htdp/image 2htdp/universe))

@(require scribble/examples racket/sandbox)
@(require 2htdp/image)


@(define core-racket
   (make-base-eval
    '(require racket/match)
    '(require 2htdp/image)
    '(require racket/math)))

@(define-syntax-rule (ex e ...)
  (filebox (emph "Racket REPL")
    (examples #:eval core-racket #:label #f e ...)))


@title[#:style '(toc unnumbered)]{Picture This}

OK, now let's do something a little more interesting.

In your web browser, go to the page for the course notes:

@link["http://www.cs.umd.edu/class/winter2021/cmsc388Q/Notes.html"]{http://www.cs.umd.edu/class/winter2021/cmsc388Q/Notes.html}

Right click the image of the blue spaceship and select
``Copy image.'' Now go back to DrRacket and paste (Ctl+V) in
the REPL and press Enter. You should see something like this:

@(define ss (bitmap/url "http://www.cs.umd.edu/class/winter2021/cmsc388Q/shipBlue_manned.png"))
@(core-racket `(define ss (bitmap/url "http://www.cs.umd.edu/class/winter2021/cmsc388Q/shipBlue_manned.png")))

@ex[(eval:alts #,ss ss)]

What you see here is that images are just another kind of
values in Racket. Just like the literal @racket[7] is a
value which means the number 7:

@ex[7]

The blue spaceship is a literal value that means the blue
space ship image.

You can do things like put it in a list:

@ex[(eval:alts (cons #,ss '()) (list ss))]

Just as there are operations on lists, there are operations on images.

These operations are available in the @racketmodname{2htdp/image}
library. To import the library, run:

@ex[(require 2htdp/image)]

This makes a bunch of operations available to us.

We can give the spaceship value a name:

@ex[(eval:alts (define spaceship
                 #,ss) (define spaceship ss))]

Now refering to that name means the blue spaceship image:

@ex[spaceship]

There are things like @racket[image-width] for computing the
width (in pixels) of an image:

@ex[(image-width spaceship)]

As you've probably guessed, there's also @racket[image-height].
But we can also do things like this:

@ex[(rotate 35 spaceship)]

We can @racket[scale]:

@ex[(scale 2 spaceship)
    (scale .1 spaceship)]

There are operations for making new images:

@ex[(rectangle 400 200 "solid" "yellow")]

And there are operations for combining images. The
@racket[overlay] is conceputally like @racket[+] but for
images: it takes two images and combines them together into
an image. It combines the given images by placing the first
one on top of the second:

@ex[(overlay spaceship
             (rectangle 400 200 "solid" "yellow"))]

We could of course, first scale the spaceship before placing
on the background:

@ex[(overlay (scale .7 spaceship)
             (rectangle 400 200 "solid" "yellow"))]

So you can see that it's pretty easy to programmatically
construct images or you can copy and paste things into the
source code itself, or you can load things off the file
system or internet.

To learn more about what's possible, read the
@racketmodname[2htdp/image] library. You can right-click any
identifier provided by the library and select ``view
documentation'' to see the docs for that function.

Alright, now let's do something a little more animated.

Let's make a function that is given an angle and produces a
spaceship rotated by that many degrees:

@ex[(define (spin i)
      (rotate i spaceship))]

We can use it like this:

@ex[(spin 0)
    (spin 1)
    (spin 2)
    (spin 90)
    (spin 180)]

We could make a big list of images using
@racket[build-list]. Here is how @racket[build-list] works:

@ex[(build-list 5 add1)
    (build-list 5 sqr)]

Now:

@ex[(build-list 45 spin)]

Notice how when you were scrolling it might've looked at
times like the spaceship was moving. An animation, after
all, is just a collection of still pictures which are shown
in rapid succession to trick our eyes into seeing movement.


There's a related library called
@racketmodname[2htdp/universe] that provides a function
called @racket[animate] that does just this: try running

@racketblock[
 (require 2htdp/universe)
 (animate spin)
]

The @racket[animate] function is given a function from
natural numbers to images and calls the function with 0, 1,
2, etc. at a rate of 28 times per second, showing the
results in a new window.

It's a little unfortunate that the animation looks bad
because as the image rotate, it's dimensions change are
cropped by the window. We can clean things up by placing the
spaceship on a larger background image.  Here's a revised
version of @racket[spin]:

@ex[(define (spin i)
      (overlay (rotate i spaceship)
               (empty-scene (* 2 (image-width spaceship))
                            (* 2 (image-height spaceship)))))
    (spin 0)
    (spin 45)
    (spin 90)]

Now try the animation again.

The @racket[animate] function is actually a simple use of a
more general system called @racket[big-bang]. To achieve the
same result, we could have written:

@racketblock[
 (big-bang 0
   [on-tick add1 1/28]
   [to-draw spin])
 ]

The @racket[big-bang] system generalizes @racket[animate] in
that you have control over how ``counting'' works. You
specify where to start and how to go from the current moment
in time to the next. In fact, you don't even have to count
with numbers; you can count from an arbitrary value.
Whatever function you give for the @racket[on-tick] clause
specifies how to go from the current value to the next
value. These values are rendered into pictorial form with
the function given in @racket[to-draw] clause.

Be sure to read the @racket[big-bang] documentation for
details.



    