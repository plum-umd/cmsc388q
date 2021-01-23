#lang racket
(require racket/gui/base)
(require opengl)
(require opengl/util)

(define KEYMOVE 0.1)

(define (draw-square x y)
  (glClearColor 0.0 0.0 0.0 0.0)
  (glClear GL_COLOR_BUFFER_BIT)
  (glColor3d 0.7 0.4 0.8)

  (glMatrixMode GL_PROJECTION)
  (glLoadIdentity)
  (glOrtho 0.0 1.0 0.0 1.0 -1.0 1.0)
  (glMatrixMode GL_MODELVIEW)
  (glLoadIdentity)

  (glBegin GL_QUADS)
  (glVertex3d (+ 0.25 x) (+ 0.25 y) 0.0)
  (glVertex3d (+ 0.75 x) (+ 0.25 y) 0.0)
  (glVertex3d (+ 0.75 x) (+ 0.75 y) 0.0)
  (glVertex3d (+ 0.25 x) (+ 0.75 y) 0.0)
  (glEnd)
  )

; setting up canvas based on this: https://lists.racket-lang.org/users/archive/2010-October/042474.html
(define glcanvas%
  (class* canvas% ()
    (inherit with-gl-context swap-gl-buffers)

   (define/override (on-paint)
      (with-gl-context
        (lambda ()
          (draw-square (get-field x this) (get-field y this))
          (swap-gl-buffers)
        )
      )
    )
    (define/override (on-size width height)
      (with-gl-context
          (lambda ()
            (glViewport 0 0 width height)
            #t
            )
        )
    )
    (init-field [x 0])
    (init-field [y 0])
    (define/override (on-char ch)
      (cond
        [(eq? (send ch get-key-code) 'left)  (print "left")];(set-field!  x (- x KEYMOVE) this)]
        [(eq? (send ch get-key-code) 'right)  (set-field! x (+ x KEYMOVE) this)]
        [(eq? (send ch get-key-code) 'down)  (set-field! y (+ x KEYMOVE) this)]
        [(eq? (send ch get-key-code) 'up)  (set-field! y (- x KEYMOVE) this)]
        [else ch]))
    (super-instantiate () (style '(gl)))
  )
)
(define frame (new frame% [label "cube"]))
(define canvas
  (new glcanvas%
       [parent frame]
       [min-width 600]
       [min-height 600]
       [stretchable-width #f]
       [stretchable-height #f]))
(send frame show #t)
