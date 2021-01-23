#lang racket

(require ffi/unsafe
         ffi/unsafe/define)

(provide
 ginit
 gplay)
 

;; Usage of GStreamer library is inspired by https://github.com/takikawa/racket-player.
;; Requires GStreamer to be installed: https://gstreamer.freedesktop.org/documentation/installing/index.html.

(define-ffi-definer define-gstreamer
  (ffi-lib "libgstreamer-1.0"))

;; TYPES
(define _GstElement
  (_cpointer 'GstElement))
(define _GstState
  (_enum '(void-pending null ready paused playing)))
(define _GstStateChangeReturn
  (_enum '(failure success async no-preroll)))
(define _GstBus
  (_cpointer 'GstBus))


;; GSTREAMER FUNCTIONS

; initialize GStreamer
(define-gstreamer
  gst_init (_fun _pointer _pointer -> _void))

; create a simple player pipeline providing convenient string description
; the second argument is GError**, which is ignored in this implementation
(define-gstreamer
  gst_parse_launch (_fun _string _pointer -> _GstElement))

; set the state of an element (playing, paused, etc.)
(define-gstreamer
  gst_element_set_state (_fun _GstElement _GstState -> _GstStateChangeReturn))

; retrieve the bus of the pipeline
(define-gstreamer
  gst_element_get_bus (_fun _GstElement -> _GstBus))

; decrement the reference count on object
(define-gstreamer
  gst_object_unref (_fun _pointer -> _void))


;; RACKET FUNCTIONS

; initialize GStreamer
(define (ginit)
  (gst_init #f #f))

; play the given file
; ! not working
; every time this is run with a local file using file://, DrRacket crashes.
; works fine with https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm though
; tested the same approach with C code and it worked fine, not sure what the problem is
(define (gplay path)
  (define pipeline
    (gst_parse_launch (string-append "playbin uri=file://" (path->string path)) #f))
  (gst_element_set_state pipeline 'playing))
