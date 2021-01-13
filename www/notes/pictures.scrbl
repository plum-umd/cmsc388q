#lang scribble/manual
@(require "../utils.rkt")


@(require scribble/examples racket/sandbox)
@(require 2htdp/image)


@(define core-racket
   (make-base-eval
    '(require racket/match)
    '(require 2htdp/image)))

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
